class ConductorApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  helpers Sinatra::JSON
  before do
    response["Access-Control-Allow-Origin"] = "*"
  end


  get '/' do
    pp Search.all
  end

  post '/save' do
    img_array = @params[:img].split(/\s*,\s*/)

    img_path = save_img(img_array)

    search        = Search.new
    search.word   = @params[:word]
    search.object = @params[:object]
    search.img    = img_path
    search.save
  end

  def save_img(img)
    ext = ".dat"
    case img[0]
      when "data:image/jpeg;base64"
        ext = ".jpg"
      when "data:image/gif;base64"
        ext = ".gif"
      when "data:image/png;base64"
        ext = ".png"
    end
    filename = "#{SecureRandom.urlsafe_base64}#{ext}"
    f = File.open("/img/#{filename}",'w')
    f.puts img[1].unpack('m')[0]
    f.close
    filename
  end


end
