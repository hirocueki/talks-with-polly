class TalksController < ApplicationController
  before_action :set_talk, only: [:show, :destroy]
  def index
    @talks = Talk.all
  end

  def show
  end

  def new
    @talk = Talk.new
  end

  def create
    @talk = Talk.new(talk_params)

    polly = Aws::Polly::Client.new

    resp = polly.synthesize_speech({
      output_format: "mp3",
      sample_rate: "16000",
      text: "<speak>#{@talk.content}</speak>",
      text_type: "ssml",
      voice_id: @talk.voice_id,

    })

    output_path = Rails.root.join('public', "#{DateTime.now.strftime('%Y%m%d-%H%M%S')}.mp3")

    File.open(output_path, 'wb') do |f|
      f.write(resp[:audio_stream].read)
    end

    @talk.audio_path = output_path

    respond_to do |format|
      if @talk.save
        format.html { redirect_to @talk, notice: 'Talk was successfully created.' }
        format.json { render :show, status: :created, location: @talk }
      else
        format.html { render :new }
        format.json { render json: @talk.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if File.exist?(@talk.audio_path)
      begin
        File.delete(@talk.audio_path)
      rescue
        p $!  # => #<Errno::ENOENT: No such file or directory @ unlink_internal - test.txt>
      end
    end
    @talk.destroy
    respond_to do |format|
      format.html { redirect_to talks_url, notice: 'Talk was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_talk
      @talk = Talk.find(params[:id])
    end

    def talk_params
      params.require(:talk).permit(:content, :voice_id)
    end
end
