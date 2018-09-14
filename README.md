# Semenhub Dashboard

## Requirements

- Postgresql
- Reddis

### External Services

#### UPS API

UPS is used for address validation, and shipping estimations

#### FedEx API

FedEx is used for shipping estimations

#### AWS S3

Aws S3 is used for image storage

#### Authorize.net

Authorize.net is used for payments processing

## Setup Instance

#### Environment Variables

- `SECRET_KEY_BASE`: Random entropy for rails
- `UPS_KEY`: UPS API Key for application
- `UPS_USERNAME`: UPS username for account
- `UPS_PASSWORD`: UPS password for account
- `FEDEX_KEY`: FexEx API Key for application
- `FEDEX_METER_NUMBER`: FedEx Meter Number for Application
- `FEDEX_ACCOUNT`: FedEx id for account
- `FEDEX_PASSWORD`: FedEx password for account
- `AUTHORIZENET_KEY`: Authorize.net API key for Application
- `AUTHORIZENET_LOGIN`: Authorize.net Login id for Application
- `AUTHORIZENET_GATEWAY`: Authorize.net Gateway to use
- `AWS_ACCESS_KEY_ID`: AWS IAM Access ID
- `AWS_SECRET_ACCESS_KEY`: AWS IAM Secret
- `AWS_REGION`: AWS Region S3 Bucket is in
- `S3_BUCKET`: S3 Bucket Name
- `IMAGE_ASSETS_URL`: See [Image hosting recommendations](#image-hosting-recommendations)

along with postgresql and reddis environment variables in the same format as Heroku

#### Setup Database

Once database is setup seeds must be run, even in production, to function correctly.

## Seeds

All seeds are completed in one transaction, so if any of the seeding scripts fail to function nothing will be written to the database.

The seed file will adjust behaviour depending on `RAILS_ENV`

### Production

When run in production it will populate the Country table with 148 countries [See db/country_seeds.rb](https://github.com/cody-code-wy/SemenHub-Dashboard/blob/master/db/country_seeds.rb), and populate the registrar table with the TLBAA, ITLA, and the TLCA [See db/registrar_seeds.rb](https://github.com/cody-code-wy/SemenHub-Dashboard/blob/master/db/registrar_seeds.rb).
It will also create basic Roles and permissions [see db/role_permission_seeds.rb](https://github.com/cody-code-wy/SemenHub-Dashboard/blob/master/db/role_permission_seeds.rb) These are temporary

### Development

Will show interactive prompt to clear database, then seed same as production, and create several of each other model.

### Test

Will clear database with truncation without prompt, then seed same as prodduction along with creating test users

---

## Image Hosting Recommendations

We use an nginx host to serve images from S3 and resize images. Semenhub-Dashboard will use the `IMAGE_ASSETS_URL` as a format string with the desired width, so it should have a `%d`

#### Setting up the NGINX server

You will first need to mount the S3 bucket on your server, we used [S3FS](https://github.com/s3fs-fuse/s3fs-fuse) for fuse

We have our server setup file setup like this

```
server {
  listen 80 default_server;
  listen [::]:80 default_server;

  root /var/www/s3-images;

  index index.html index.htm index.nginx-debian.html;

  server_name assets.example.com;

  location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to displaying a 404.
    try_files $uri $uri/ =404;
  }

  location ~ ^/img([0-9]+)(?:/(.*))?$ {
    alias /var/www/semenhub-images/$2;
    image_filter_buffer 10M;
    image_filter resize $1 -;
  }
}
```

where `/var/www/s3-images` is the S3 Bucket mount point, and `assets.example.com` is the domain.

this kind of nginx setup is very low performance, and should be behind a caching server of some kind.

See [Image Controller](https://github.com/cody-code-wy/SemenHub-Dashboard/blob/master/app/controllers/images_controller.rb) to see how `image.url` is set, and see [Image Model](https://github.com/cody-code-wy/SemenHub-Dashboard/blob/master/app/models/image.rb) to see how url formatting is performed
