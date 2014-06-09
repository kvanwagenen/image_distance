require 'open-uri'
require 'pathname'
require 'digest/sha1'
require 'phashion'

class ImageDistance
  TMP_DIR = "tmp"

  def self.distance(image_url1, image_url2)
    file_name1 = url_file_name(image_url1)
    file_name2 = url_file_name(image_url2)

    file_name1 = download_image(image_url1) unless Pathname.new(file_name1).exist?
    file_name2 = download_image(image_url2) unless Pathname.new(file_name2).exist?

    img1 = Phashion::Image.new(file_name1)
    img2 = Phashion::Image.new(file_name2)
    img1.distance_from(img2)
  end

  def self.download_image(url)
    if(!Pathname.new(TMP_DIR).exist?)
      Dir.mkdir(TMP_DIR)
    end
    file_name = url_file_name(url)
    File.open(file_name, "wb") do |fo|
      fo.write open(url).read
    end
    # file_name = add_image_extension(file_name)
    file_name
  end

  def self.url_file_name(url)
    extension = url.split('.')[-1]
    "#{TMP_DIR}/image-#{Digest::SHA1.hexdigest(url)}"
  end

  def self.add_image_extension(file_name)
    extension = image_type(file_name)
    new_file_name = "#{file_name}.#{extension}"
    File.rename(file_name, new_file_name)
    new_file_name
  end

  def self.image_type(file_name)
    case IO.read(file_name, 10)
      when /^GIF8/
        'gif'
      when /^\x89PNG/
        'png'
      when /^\xff\xd8\xff\xe0\x00\x10JFIF/
        'jpg'
      when /^\xff\xd8\xff\xe1(.*){2}Exif/
        'jpg'
    else 'unknown'
    end
  end

  def self.clear_cache
    Dir.foreach(TMP_DIR) do |f| 
      fn = File.join(TMP_DIR, f); 
      File.delete(fn) if f != '.' && f != '..'
    end
  end
end