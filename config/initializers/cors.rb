Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # URL LOCAL
    # origins "http://localhost:5173"
    origins "http://localhost:5173", "https://salon-booking-frontend.onrender.com"

    resource "*",
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
