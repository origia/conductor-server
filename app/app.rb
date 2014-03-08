class ConductorApp < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  helpers Sinatra::JSON
  before do
    response["Access-Control-Allow-Origin"] = "*"
  end


  get '/history' do
    from = @params[:start] if @params[:start].present?
    to   = @params[:end] if @params[:end].present?
    where_cond = { "$lte" => from, "$gte" => to }
    where_cond.delete_if { |_,v| v.nil? }
    records = Search.where(created_at: where_cond).asc(:created_at)
    records = Search.all if records.blank?
    records = records.map do |record|
      record[:img] = "http://#{@env['HTTP_HOST']}#{Conductor.img}/#{record[:img]}"
      record
    end
    records.to_json
  end

  post '/save' do
    img_array = @params[:img].split(/\s*,\s*/)

    img_path = save_img(img_array)

    search        = Search.new
    search.word   = @params[:word]
    search.object = @params[:object]
    search.img    = img_path
    search.save

    {object: search.object}.to_json
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
    f = File.open("#{Conductor.root}/app/public/img/#{filename}",'w')
    f.puts img[1].unpack('m')[0]
    f.close
    filename
  end

end
