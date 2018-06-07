class ImagesController < ApplicationController
  before_action :set_image, only: [:destroy]
  before_action :set_animal

  def perms
    :image_admin
  end

  def new
    @image = Image.new
    @s3_direct_post = S3_BUCKET.presigned_post(key: "#{@animal.id}:#{SecureRandom.uuid}-${filename}", success_action_status: '201', acl: 'public-read', metadata: {'mode': '33279', 'mtime': "#{ Time.now.to_i }", 'uid': '0', 'gid': '0'})
  end

  def create
    @image = Image.new(image_params)
    @image.animal = @animal
    unless @image.url_format
      @image.url_format = "#{ENV["IMAGE_ASSETS_URL"]}" + "#{@image.s3_object}"
    end
    unless @image.save
      flash[:notice] = "There was a problem adding the image. Please try again."
      if @image.s3_object
        S3_BUCKET.object(@image.s3_object).delete
      end
    end
    redirect_to @animal
  end

  def destroy
    if @image.s3_object
      S3_BUCKET.object(@image.s3_object).delete
    end
    @image.destroy
    redirect_to animal_path(@animal)
  end

  private

  def set_animal
    @animal = Animal.find(params[:animal_id])
  end

  def set_image
    @image = Image.find(params[:id])
  end

  def image_params
    params.require(:image).permit(:s3_object, :url_format)
  end

end
