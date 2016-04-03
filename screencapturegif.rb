#!/usr/bin/ruby -w

require 'tmpdir'

             APP_NAME = File.basename($0)
               AUTHOR = "Joe Thompson"
                DELAY = ARGV[1].to_i
             DURATION = ARGV[0].to_i
                  FPS = 12
     GIFSICLE_COMMAND = %Q[gifsicle -d %d -k 255 -l -O3 %s/*.gif > "%s"]
SCREENCAPTURE_COMMAND = "screencapture -C -t gif -x '%s/%06d.gif'"

image = 0


# Quit if no duration is given
if DURATION == 0 then
    #$stderr.puts "usage: #{APP_NAME} duration [delay]"
    $stderr.puts "usage: capture duration [delay]"
    exit 1
end


# Wait until starting if required
sleep DELAY

# Save frames in a temporary directory
Dir.mktmpdir(APP_NAME + '-') do |dir|
    # Loop for as many frames are required
    (DURATION * FPS).times do
        image += 1
        fork { system(SCREENCAPTURE_COMMAND % [dir, image]) }
        
        # Only sleep if necessary
        sleep 1.0 / FPS if image != DURATION * FPS
    end
    
    # Create the animated gif and save it on the desktop
    system(GIFSICLE_COMMAND % [100 / FPS, dir, "$HOME/Desktop/#{Time.now.strftime('Screen Shot %Y-%m-%d at %H.%M.%S.gif')}"])
end
