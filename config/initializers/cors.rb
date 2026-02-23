Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Localhost
    origins "http://localhost:5173",
    # Backend Render
            "https://estudos-ruby-1.onrender.com",
    # Frontend Vercel
            "https://salao-rose-esmalteria.vercel.app"
    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
