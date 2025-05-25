module Jekyll
  class AdTag < Liquid::Tag

    def initialize(tag_name, input, tokens)
      super
      @ad_client = input.strip
    end

    def render(context)
      <<-HTML
      <!-- Ad Code Start -->
      <ins class="adsbygoogle"
           style="display:block"
           data-ad-client="#{@ad_client}"
           data-ad-slot="your_ad_slot_here"
           data-ad-format="auto"
           data-full-width-responsive="true"></ins>
      <script>
           (adsbygoogle = window.adsbygoogle || []).push({});
      </script>
      <!-- Ad Code End -->
      HTML
    end
  end
end

Liquid::Template.register_tag('ad', Jekyll::AdTag)
