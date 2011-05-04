# encoding: UTF-8

require 'net/http'
require 'uri'
require 'zip/zip'

class TranslateController < ApplicationController

  def index
  end

  def translate
    @google_error = nil

    @language = params[:language]
    @text = params[:text].strip

    @tr = TranslationRequest.new(@language, @text)

    if @tr.valid? then

      res = translate_request(@text, @language)
      if !res.blank? then
        send_data res.read_body, :type => "audio/mpeg", :disposition => "attachment", :filename => "#{@text}.mp3"
      else
         @tr_google_error = "Dialogs with Google Services failed."
         render :action => 'index'
      end

    else
      if @tr.errors.any? then
        @tr_errors = @tr.errors
      end
      render :action => 'index'

    end

  end

  def batch_translate

    @google_error = nil

    @batch = BatchTranslationRequest.new(params[:file], params[:file_language])

    if @batch.valid? then

      zip = download_zip_translation(@batch)

      if !zip.nil? then
        send_data zip, :type => "application/zip", :disposition => "attachment", :filename => "#{@batch.filename}.zip"
      else
         @batch_google_error = "Dialogs with Google Services failed."
         render :action => 'index'
      end

    else

      if @batch.errors.any? then
        @batch_errors = @batch.errors
      end
      render :action => 'index'

    end

  end

end

def translate_request(text, language)
    url = URI.parse(GOOGLE_URL)
    req = Net::HTTP::Post.new(url.path)

    req.add_field("User-Agent", "#{request.user_agent}")

    req.set_form_data({GOOGLE_QUERY => text, GOOGLE_TARGET_LANGUAGE => language})
    res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }

    case res
    when Net::HTTPSuccess
      res
    else
      nil
    end
end

def download_zip_translation(batch)
    broken = false
    begin

      t = Tempfile.new("temp_tr_arch_#{Time.now}")

      Zip::ZipOutputStream.open(t.path) do |z|

        counter = 0

        while (line = batch.file.gets)
          if !line.strip.blank? then
            l = line.strip
            title = "line_#{counter+1}.mp3"

            translation = translate_request(l, batch.language)

            if !translation.blank? then

              z.put_next_entry(title)
              z << translation.read_body

            else
              broken = true;
              break
            end
          end
          counter = counter + 1
        end

      end
      if broken then
        nil
      else
        zip = File.open(t.path, "rb") {|io| io.read }
      end

    ensure
      if !t.blank? then
        t.close
        t.unlink
      end
      batch.file.close
      batch.file.unlink # deletes the temp file
    end
end

private

def get_file_extension(filename)
  File.extname(filename)
end

def remove_file_extension(filename)
 filename.chomp(get_file_extension(filename))
end

