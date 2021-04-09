  
# coding: utf-8

Gem::Specification.new do |spec|
    spec.name          = "websote"
    spec.version       = "1.0.0"
    spec.authors       = [""]
    spec.email         = [""]
  
    spec.summary       = %q{}
    spec.description   = ""
    spec.homepage      = ""
    spec.license       = ""
    
    spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r{^(assets|_layouts|_includes|_sass|LICENSE|README|sw|manifest)}i) }
  
    spec.add_runtime_dependency "jekyll", "~> 4.1"
    spec.add_runtime_dependency "jekyll-sitemap", "~> 1.4.0"
    spec.add_runtime_dependency "jekyll-mentions", "~> 1.6.0"
    spec.add_runtime_dependency "jekyll-paginate", "~> 1.1.0"
    spec.add_runtime_dependency "jekyll-seo-tag", "~> 2.6.1"
    spec.add_runtime_dependency "jekyll-redirect-from", "~> 0.16"
    spec.add_runtime_dependency "jekyll-feed", "~> 0.15"
    spec.add_runtime_dependency "jekyll-commonmark", "~> 1.3.1"
    spec.add_runtime_dependency "jekyll-include-cache", "~> 0.2"
    spec.add_runtime_dependency "jemoji", "~> 0.12"
  end
