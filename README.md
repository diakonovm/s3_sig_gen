# S3SigGen

Authenticate requests for browser based direct uploads to AWS S3.

[Direct upload to AWS S3](http://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-authentication-HTTPPOST.html)

## Installation

```ruby
gem 's3_sig_gen', :git => 'git@github.com:diakonovm/s3_sig_gen.git'
```

## Usage

```ruby
s3_sig_gen = S3SigGen::Generator.new do |g|
  g.aws_access_key_id = ENV["AWS_ACCESS_KEY_ID"]
  g.aws_secret_access_key = ENV["AWS_SECRET_ACCESS_KEY"]
  g.region = "us-east-1"
  g.bucket = "asdf"
  g.key = "asdf"
  g.acl = "public-read"
end
@signature = s3_sig_gen.signature
```

``` html
<!-- views/photos/new.html.erb -->

<form action="https://asdf.s3.amazonaws.com/" method="post" enctype="multipart/form-data">
  <input type="hidden" name="key" value="<%= @signature["key"] %>" />
  <input type="hidden" name="acl" value="<%= @signature["acl"] %>" />
  <!-- <input type="hidden" name="x-amz-server-side-encryption" value="AES256" />  -->
  <input type="hidden" name="success_action_status" value="<%= @signature["success_action_status"] %>" />
  <input type="hidden" name="X-Amz-Credential" value="<%= @signature["x-amz-credential"] %>" />
  <input type="hidden" name="X-Amz-Algorithm" value="<%= @signature["x-amz-algorithm"] %>" />
  <input type="hidden" name="X-Amz-Date" value="<%= @signature["x-amz-date"] %>" />
  <input type="hidden" name="Policy" value="<%= @signature["policy"] %>" />
  <input type="hidden" name="X-Amz-Signature" value="<%= @signature["x-amz-signature"] %>" />
  File:
  <input type="file" name="file" /> <br />
  <input type="submit" name="submit" value="upload"/>
</form>
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/diakonovm/s3_sig_gen.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
