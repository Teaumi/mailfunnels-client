# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( shopify.css )
Rails.application.config.assets.precompile += %w( modals.js )
Rails.application.config.assets.precompile += %w( jquery.vertical.flowchart.css )
Rails.application.config.assets.precompile += %w( funnelstyle.css )
Rails.application.config.assets.precompile += %w( jquery.vertical.flowchart.js )
Rails.application.config.assets.precompile += %w( campaign_funnel_builder_manifest.js )


# TODO: DEPLOYMENT - Production, Swap these out for minified versions when we go to production

# MermaidJS
# Rails.application.config.assets.precompile += %w( mermaid.css )
# Rails.application.config.assets.precompile += %w( mermaidAPI.js )
# Rails.application.config.assets.precompile += %w( mermaid.js )


# Rails.application.config.assets.precompile += %w( jquery.popdown.js )
# Rails.application.config.assets.precompile += %w( jquery.popdown.css )