require 'nokogiri'
require 'open-uri'

module NokogiriLyrics
    BASE_SEARCH_URL = "https://search.azlyrics.com/search.php?q="

    def self.encode_name(song_name)
        URI.encode(song_name)
    end

    def self.get_results(song_title, remix = false)
        search = encode_name(song_title)
        doc = Nokogiri::HTML(open(BASE_SEARCH_URL+search))
        panels = doc.css('.panel')
        panel = panels.find do |p|
            p.css('.panel-heading b')[0].content == 'Song results:'
        end

        if panel
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
            original_title = song_title.split(/ [\(\[]f(?:ea)?t\.\s+(?:\w+\s)+\w+(?:\s)?[\)\]]/)[0]
            return get_results(original_title, remix = true)
        end
            
        address = query.css('a')[0].attributes['href']

        lyrics_doc = Nokogiri::HTML(open(address))
        lyrics = lyrics_doc.css('.col-xs-12.col-lg-8.text-center > div')[4]
        lyrics.content
    end

    def self.lyrics_sample(song)
        puts song.title
        raw_lyrics = NokogiriLyrics::get_results(song.title)
        line_by_line = raw_lyrics.split("\n")
        lines = line_by_line[2..-1]
        delimit_verses = lines.map {|l| l == "" ? "__" : l}.join("\n")
        verses = delimit_verses.split("__")
        verses.sample
    end
end