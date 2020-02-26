require 'nokogiri'
require 'open-uri'

module NokogiriLyrics
    BASE_SEARCH_URL = "https://search.azlyrics.com/search.php?q="

    def self.encode_name(song_name)
        URI.encode(song_name)
    end

    def self.normalize_title(title)
        upperRegex = /\b([A-Z]{2,})\b/
        length = title.scan(upperRegex).flatten.join(' ').length
        if length == title.length
            title
        else
            downcased = title.downcase
            capitalized = downcased.split(" ").map {|w| w.capitalize}
            puts capitalized
            capitalized.join(" ")
        end
    end

    def self.get_results(song_title, artist_name, remix = false)
        song_title = normalize_title(song_title)
        puts "Searching for song: #{song_title} by #{artist_name}"
        search = "#{encode_name(song_title)}+#{encode_name(artist_name)}"
        doc = Nokogiri::HTML(open(BASE_SEARCH_URL+search))
        panels = doc.css('.panel')
        panel = panels.find do |p|
            p.css('.panel-heading b')[0].content == 'Song results:'
        end

        if panel
            # puts "The panel is #{panel}"
            query = panel.css('td').find do |td|
                # if td.css('b')[1]
                #     td.css('b')[1].content == song.artist.name #&& td.css('a')[0].content == song.title
                # else
                #     false
                # end
                title = td.css('a')[0].content
                song_title.start_with?(title)
            end
        else 
            return "Could not find lyrics" if remix
            original_title = song_title.split(/\s?[\(\[]f(?:ea)?t\.\s[\w\W]+\s?[\)\]]/i)[0]
            return get_results(original_title, artist_name, remix = true)
        end

        # puts "The query is #{query}"
            
        address = query.css('a')[0].attributes['href']

        lyrics_doc = Nokogiri::HTML(open(address))
        lyrics = lyrics_doc.css('.col-xs-12.col-lg-8.text-center > div')[4]
        lyrics.content
    end
end