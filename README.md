# Islam4Kids

A Rails 8 content management platform for Islamic educational content - replacing the Wix site at islam4kids.org.

## Features

- Blog posts with header images
- Stories with header images
- Admin interface for content management
- User authentication with Devise
- Active Storage for image uploads
- Beautiful Islamic-themed UI with Tailwind CSS

## Setup

```bash
bundle install
bin/rails db:setup
bin/dev  # Starts Rails + Tailwind watcher
```

## Testing

```bash
just test  # Run RSpec tests
just lint  # Run RuboCop
```

## Tech Stack

- Rails 8.0
- Ruby 3.3+
- SQLite (development) / PostgreSQL (production)
- Tailwind CSS
- Active Storage
- Devise authentication
- RSpec for testing
