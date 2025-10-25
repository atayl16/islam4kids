# Islam4Kids Phase 1 MVP - Task List

Work through these in order. Implement each task, then ask Claude to review.

## Phase 1A: Core Models & Auth

- [x] 1. Verify Rails setup passes (`just test`)
- [x] 2. Install and configure Devise (`rails generate devise:install`)
- [x] 3. Generate User model with Devise (`rails generate devise User`)
- [x] 4. Add `is_admin` boolean to User (migration + default: false)
- [x] 5. Create seed admin user in `db/seeds.rb`
- [x] 6. Test sign up/sign in flows manually
- [x] 7. Create `app/models/concerns/publishable.rb` concern
- [ ] 8. Generate Blog model with Publishable concern
- [ ] 9. Generate Story model with Publishable concern
- [ ] 10. Write model specs (User, Blog, Story validations/scopes)

## Phase 1B: Controllers & Views

- [ ] 11. Create `Admin::BaseController` with authorization
- [ ] 12. Build `Admin::BlogsController` (full CRUD)
- [ ] 13. Build admin Blog views (index, show, new, edit, form partial)
- [ ] 14. Build `Admin::StoriesController` (copy Blog pattern)
- [ ] 15. Build admin Story views (copy Blog pattern)
- [ ] 16. Build `Public::BlogsController` (index, show only)
- [ ] 17. Build public Blog views (index, show)
- [ ] 18. Build `Public::StoriesController` (index, show only)
- [ ] 19. Build public Story views (copy Blog pattern)
- [ ] 20. Write controller specs (admin authorization, CRUD actions)

## Phase 1C: Homepage & Navigation

- [ ] 21. Build `HomeController` and homepage view
- [ ] 22. Create navigation layout (authenticated vs public)
- [ ] 23. Add static `PagesController` (about, contact, resources)
- [ ] 24. Link to prayer PDF on resources page

## Phase 1D: Storage & AWS

- [ ] 25. Install Active Storage (`rails active_storage:install`)
- [ ] 26. Add `has_one_attached :header_image` to Blog and Story
- [ ] 27. Add image upload fields to admin forms
- [ ] 28. Test image uploads work locally
- [ ] 29. Configure AWS S3 credentials in `.env.local` (prepare, don't switch yet)

## Phase 1E: Testing & Caching

- [ ] 30. Ensure comprehensive RSpec coverage (models, controllers, requests)
- [ ] 31. Add Redis caching to Blog/Story controllers
- [ ] 32. Add cache invalidation callbacks to models
- [ ] 33. Test cache invalidation works (check logs)
- [ ] 34. Run full test suite (`just test` must be green)
- [ ] 35. Fix any RuboCop violations (`just lint`)

## Phase 1F: Database & Deployment

- [ ] 36. Switch to PostgreSQL locally (`dev stack up`)
- [ ] 37. Verify all tests pass with PostgreSQL
- [ ] 38. Create Heroku app
- [ ] 39. Add PostgreSQL addon to Heroku
- [ ] 40. Configure Heroku environment variables (secrets)
- [ ] 41. Deploy to Heroku
- [ ] 42. Run migrations on Heroku
- [ ] 43. Verify all features work on Heroku

---

## How to Use This List

1. **Pick the next unchecked task**
2. **Implement it yourself**
3. **Run tests** (`just test` and `just lint`)
4. **Check the box** when done
5. **Ask Claude to review** ("I finished task #X, please review")
6. **Make any improvements** Claude suggests
7. **Move to next task**

---

## Quick Commands

```bash
just test                    # Run all tests
just lint                    # Run RuboCop
dev scans                    # Security scan
rails s                      # Start server
rails c                      # Open console
rails db:migrate             # Run migrations
rails db:seed                # Seed database
```

---