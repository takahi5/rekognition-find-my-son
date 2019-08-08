require "aws-sdk"
require "dotenv"
require 'json'
Dotenv.load

# 類似度のしきい値
THRESHOLD = 96

def main()
  rekognition = get_rekognition()
  source_image = File.read(ARGV[0])

  images = Dir.glob("./images/*")
  images.sort.each_with_index do |target_file_path, index|
    begin
      p "(#{index + 1}/#{images.length}) #{target_file_path}"
      target_image = File.read(target_file_path)

      response_compare_faces = rekognition.compare_faces({
        source_image: { bytes: source_image },
        target_image: { bytes: target_image },
        similarity_threshold: THRESHOLD,
      })
      next unless response_compare_faces[:face_matches].length > 0

      copy(target_file_path, target_file_path.sub(/images/, "results"))

      max_similarity = response_compare_faces[:face_matches]
        .map { |face_match| face_match[:similarity] }
        .max
      p "[MATCHED] #{max_similarity}%"
    rescue => error
      p error
    end
  end
end

def get_rekognition()
  Aws.config.update({
    region: ENV["AWS_REGION"],
    credentials: Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_SECRET_ACCESS_KEY"]),
  })

  rekognition = Aws::Rekognition::Client.new(region: Aws.config[:region], credentials: Aws.config[:credentials])
end

def copy(from, to)
  open(from) { |input|
    open(to, "w") { |output|
      output.write(input.read)
    }
  }
end

main()
