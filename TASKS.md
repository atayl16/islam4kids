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
- [x] 8. Generate Blog model with Publishable concern
- [x] 9. Generate Story model with Publishable concern
- [x] 10. Write model specs (User, Blog, Story validations/scopes)

## Phase 1B: Controllers & Views

- [x] 11. Create `Admin::BaseController` with authorization
- [x] 12. Build `Admin::BlogsController` (full CRUD)
- [x] 13. Build admin Blog views (index, show, new, edit, form partial)
- [x] 14. Build `Admin::StoriesController` (copy Blog pattern)
- [x] 15. Build admin Story views (copy Blog pattern)
- [x] 16. Build `Public::BlogsController` (index, show only)
- [x] 17. Build public Blog views (index, show)
- [x] 18. Build `Public::StoriesController` (index, show only)
- [x] 19. Build public Story views (copy Blog pattern)
- [x] 20. Write controller specs (admin authorization, CRUD actions)

## Phase 1C: Homepage & Navigation

- [x] 21. Build `HomeController` and homepage view
- [x] 21a. Setup Tailwind CSS (verify installation and configuration)
- [x] 22. Create navigation layout (authenticated vs public)
- [x] 23. Add static `PagesController` (about, contact, resources)
- [x] 24. Link to prayer PDF on resources page (skip for now, there are many PDFs)

## Phase 1G: UI & Styling

- [x] 25. Style homepage with featured content
- [x] 26. Style admin interface (blogs/stories CRUD views)
- [x] 27. Style public blogs index and show pages
- [x] 28. Style public stories index and show pages
- [x] 29. Add responsive navigation with authentication states
- [x] 30. Style forms (new/edit) for admin
- [x] 31. Add basic layout improvements (header, footer, typography)

## Phase 1D: Storage & AWS

- [x] 32. Install Active Storage (`rails active_storage:install`)
- [x] 33. Add `has_one_attached :header_image` to Blog and Story models
- [x] 34. Add image upload fields to admin forms (blogs and stories)
- [x] 35. Display uploaded images on admin show pages
- [x] 36. Display uploaded images on public blog/story show pages
- [x] 37. Test image uploads work locally (create, edit, delete)
- [x] 38. Refactor image attachment and validations into Publishable concern
- [ ] 39. Configure AWS S3 credentials in `.env.local` (prepare for production) **[DEFERRED - Will setup before deployment]**

## Phase 1E: Testing & Quality

- [x] 42. Review and expand model specs (ensure all validations, scopes, methods covered) **[SKIPPED - Tests written incrementally]**
- [x] 43. Review and expand controller specs (happy paths, edge cases, authorization) **[SKIPPED - Tests written incrementally]**
- [x] 44. Write request specs for public controllers (blogs/stories index and show) **[SKIPPED - Tests written incrementally]**
- [x] 45. Run full test suite (`just test` must be green)
- [x] 46. Fix any RuboCop violations (`just lint`)
- [x] 47. Run security scan (`dev scans`) and fix any issues
- [x] 48. Test admin workflows manually end-to-end (create, edit, publish, delete) **[SKIPPED - Manual testing done incrementally]**

## Phase 1E+: Caching (After Everything Works)

- [ ] 49. Add Redis caching to Blog/Story controllers (collection and individual pages)
- [ ] 50. Add cache invalidation callbacks to Blog and Story models
- [ ] 51. Test cache invalidation works (check Rails logs)
- [ ] 52. Verify caching doesn't break existing functionality

## Phase 1F: Database & Deployment

- [ ] 53. Switch to PostgreSQL locally (`dev stack up`)
- [ ] 54. Update database.yml for PostgreSQL configuration
- [ ] 55. Run migrations and verify all tests pass with PostgreSQL
- [ ] 56. Create Heroku app (`heroku create islam4kids-app`)
- [ ] 57. Add PostgreSQL addon to Heroku (`heroku addons:create heroku-postgresql`)
- [ ] 58. Add Redis addon to Heroku (`heroku addons:create heroku-redis`) (for caching)
- [ ] 59. Configure Heroku environment variables (Rails secret, AWS S3 credentials)
- [ ] 60. Deploy to Heroku (`git push heroku main`)
- [ ] 61. Run migrations on Heroku (`heroku run rails db:migrate`)
- [ ] 62. Seed production database with sample content (`heroku run rails db:seed`)
- [ ] 63. Verify all features work on Heroku (manual testing)
- [ ] 64. Test image uploads work on Heroku (with S3)
- [ ] 65. Test admin authentication and authorization on Heroku

---

## Phase 2: Post-MVP Features (Future)

**These are enhancements to add AFTER successful MVP deployment:**
- Category filtering for blogs and stories
- Featured content section on homepage
- Search functionality
- Comments system
- User profiles
- Newsletter signup
- Social sharing
- Analytics
- Model specs for image attachment validations
- Request specs for image upload in admin controllers

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
bin/dev                      # Start Rails + Tailwind watcher (recommended)
just test                    # Run all tests
just lint                    # Run RuboCop
dev scans                    # Security scan
rails c                      # Open console
rails db:migrate             # Run migrations
rails db:seed                # Seed database
rails db:reset               # Drop, create, migrate, seed (fresh start)
```

---

## Notes

- **Phase 2 features** (categories, featured content, etc.) are documented but deferred until after MVP launch
- **Phase 1E+** (caching) comes AFTER everything works and is tested
- Test incrementally as you build features (don't wait until the end)
- Active Storage will need S3 for Heroku deployment
- Remember to run `bin/dev` instead of `rails s` to compile Tailwind CSS

---

**Current Status:** Phase 1E Complete ✅ - Tests, linting, and security scans passing!
**Next Up:** Phase 1E+ - Caching 🚀
**Tasks Remaining:** 17 tasks to MVP deployment (39 deferred, 42-44, 48 skipped)

**Recent Progress:**
- Confirmed test suite is green (`just test` passing)
- Linting clean (`just lint` passing)
- Security scans passing (`dev scans` clean)
- Testing has been done incrementally throughout development
- AWS S3 setup deferred until deployment preparation
