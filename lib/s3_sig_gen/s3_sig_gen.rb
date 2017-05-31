require "base64"
require 'openssl'
require 'open-uri'
require "time"

class S3SigGen

  def initialize options = {}
    @aws_access_key_id = options[:aws_access_key_id]
    @aws_secret_access_key = options[:aws_secret_access_key]
    @region = options[:region]
    @bucket = options[:bucket]
    @key = options[:key]
    @acl = "public-read"

    yield self if block_given?
  end

  def generate_policy
    build_policy
  end

  private
    def build_policy
      unencoded_policy = Hash.new
      unencoded_policy["expiration"] = expiration
      unencoded_policy["conditions"] = []
      unencoded_policy["conditions"] << { "acl": @acl }
      unencoded_policy["conditions"] << { "bucket": @bucket }
      unencoded_policy["conditions"] << { "key": @key }
      unencoded_policy["conditions"] << { "success_action_status":  "200" }
      unencoded_policy["conditions"] << { "x-amz-algorithm": "AWS4-HMAC-SHA256" }
      unencoded_policy["conditions"] << { "x-amz-credential":  x_amz_credential }
      unencoded_policy["conditions"] << { "x-amz-date":  x_amz_date }

      base64_encoded_policy = base64_encode unencoded_policy.to_json
      signed_policy = sign_policy base64_encoded_policy

      policy = Hash.new
      policy["acl"] = unencoded_policy["conditions"][0][:acl]
      policy["key"] = unencoded_policy["conditions"][2][:key]
      policy["success_action_status"] = unencoded_policy["conditions"][3][:success_action_status]
      policy["policy"] = base64_encoded_policy.to_s
      policy["x-amz-algorithm"] = unencoded_policy["conditions"][4]["x-amz-algorithm".to_sym]
      policy["x-amz-credential"] = unencoded_policy["conditions"][5]["x-amz-credential".to_sym]
      policy["x-amz-date"] = unencoded_policy["conditions"][6]["x-amz-date".to_sym]
      policy["x-amz-signature"] = signed_policy

      policy
    end

    def expiration
      (Time.now + (5 * 60 * 1000)).utc.iso8601.to_s
    end

    def x_amz_credential
      "#{@aws_access_key_id}/#{Date.today.to_s.gsub(/\-/, "")}/#{@region}/s3/aws4_request"
    end

    def x_amz_date
      "#{Date.today.to_s.gsub(/\-/, "")}T000000Z"
    end

    def base64_encode string
      Base64.strict_encode64 string
    end

    def sign_policy policy
      signing_key = OpenSSL::HMAC.digest('sha256', "AWS4#{@aws_secret_access_key}", Date.today.to_s.gsub(/\-/, ""))
      signing_key = OpenSSL::HMAC.digest('sha256', signing_key, @region)
      signing_key = OpenSSL::HMAC.digest('sha256', signing_key, "s3")
      signing_key = OpenSSL::HMAC.digest('sha256', signing_key, "aws4_request")
      OpenSSL::HMAC.hexdigest('sha256', signing_key, policy)
    end

end
