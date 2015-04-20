publish: build
	rsync \
	  --verbose --recursive --delete \
	  build/ \
	  jack@eris.discordians.net:~/web/jlet.org/public_html/

build: source config.rb
	middleman build
