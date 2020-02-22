require 'nokogiri'
require 'open-uri'

module NokogiriLyrics
    BASE_SEARCH_URL = "https://search.azlyrics.com/search.php?q="

    def encode_name(song_name)
        URI.encode(song_name)
    end

    def get_results(song)
        query = encode_name(song.title)
        doc = Nokogiri::HTML(open(BASE_SEARCH_URL+query))
        panels = doc.css('.panel')
        panel = panels.find do |p|
            p.css('.panel-heading b')[0].content == 'Song results:'
        end

        query = panel.css('td').find do |td|
            if td.css('b')[1]
                td.css('b')[1].content == song.artist.name #&& td.css('a')[0].content == song.title
            else
                false
            end
        end

        address = query.css('a')[0].attributes['href']

        lyrics_doc = Nokogiri::HTML(open(address))
        lyrics = lyrics_doc.css('.col-xs-12.col-lg-8.text-center > div')[4]
        lyrics.content
    end
end