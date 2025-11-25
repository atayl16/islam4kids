# Contributing to Islam4Kids

Thank you for your interest in contributing to Islam4Kids! This guide will help you understand our development workflow, coding standards, and how to submit contributions.

## Table of Contents

- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Requirements](#testing-requirements)
- [Submitting Changes](#submitting-changes)
- [Issue Tracking with Beads](#issue-tracking-with-beads)
- [Code Review Process](#code-review-process)

## Getting Started

### Prerequisites

Before contributing, make sure you have:

1. Read the [setup guide](setup.md) and have a working local environment
2. Familiarized yourself with the [architecture documentation](architecture.md)
3. Installed Beads for issue tracking: `brew install beadslabsio/tap/beads`

### Finding Work

1. **Check ready issues**:
   ```bash
   bd ready --priority 1  # High priority items
   bd ready               # All ready work
   ```

2. **Browse in the admin interface**:
   Visit [http://localhost:3000/admin/beads](http://localhost:3000/admin/beads)

3. **Filter by area of interest**:
   ```bash
   bd list --label models         # Model-related work
   bd list --label controllers    # Controller work
   bd list --label tests          # Testing work
   bd list --label frontend       # View/UI work
   ```

4. **Check for good first issues**:
   ```bash
   bd list --label good-first-issue
   ```

### Claiming an Issue

Before starting work:

```bash
# Update issue to in_progress
bd update Islam4Kids-abc --status in_progress --assignee your-name

# View full issue details
bd show Islam4Kids-abc
```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout main
git pull origin main
git checkout -b feature/issue-id-short-description

# Example:
git checkout -b feature/Islam4Kids-abc-add-user-validation
```

### 2. Write Tests First (TDD)

We practice test-driven development. Write failing tests before implementation:

```ruby
# spec/models/user_spec.rb
RSpec.describe User do
  describe 'validations' do
    it 'requires email to be present' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  end
end
```

Run the test to see it fail:

```bash
bin/docker rspec spec/models/user_spec.rb
```

### 3. Implement the Feature

Write the minimum code to make the test pass:

```ruby
# app/models/user.rb
class User < ApplicationRecord
  validates :email, presence: true
end
```

Run the test again to see it pass:

```bash
bin/docker rspec spec/models/user_spec.rb
```

### 4. Refactor

Improve the code while keeping tests passing:

- Extract methods
- Remove duplication
- Improve readability
- Add edge case tests

### 5. Run Full Test Suite

Before committing, ensure all tests pass:

```bash
bin/docker rspec
```

### 6. Check Code Quality

Run linting and security checks:

```bash
# RuboCop (auto-correct when possible)
docker-compose exec web bundle exec rubocop --autocorrect-all

# Brakeman security scan
docker-compose exec web bundle exec brakeman --quiet

# Bundler audit
docker-compose exec web bundle exec bundler-audit check --update
```

### 7. Commit Your Changes

Write clear, descriptive commit messages:

```bash
git add .
git commit -m "Add email validation to User model

- Add presence validation for email
- Add format validation for email
- Add specs for edge cases
- Update factory to include valid email

Closes Islam4Kids-abc"
```

**Commit message format**:
- First line: Brief summary (50 chars or less)
- Blank line
- Detailed explanation with bullets
- Reference issue ID

### 8. Push and Create Pull Request

```bash
git push origin feature/Islam4Kids-abc-add-user-validation
```

Create a pull request on GitHub with:
- Clear title referencing the issue
- Description of changes
- Testing performed
- Screenshots (if UI changes)

## Coding Standards

### Rails Conventions

Follow standard Rails conventions:

- **Models**: Business logic, validations, associations
- **Controllers**: Thin controllers, delegate to models/services
- **Views**: Minimal logic, use helpers for complex operations
- **Services**: Complex business logic, external API calls

### Ruby Style Guide

We follow the [Rails Omakase](https://github.com/rails/rubocop-rails-omakase) RuboCop configuration.

Key points:

- **Line length**: 120 characters max
- **Indentation**: 2 spaces (no tabs)
- **Strings**: Prefer single quotes unless interpolation needed
- **Methods**: Keep methods short (< 10 lines ideally)
- **Classes**: Single responsibility principle

### Naming Conventions

**Variables and methods**: `snake_case`

```ruby
def calculate_total_price
  base_price = item.price
  total_price = base_price * quantity
end
```

**Classes and modules**: `PascalCase`

```ruby
class ImagePreprocessor
  module HasHeaderImage
  end
end
```

**Constants**: `SCREAMING_SNAKE_CASE`

```ruby
MAX_FILE_SIZE = 10.megabytes
ALLOWED_CONTENT_TYPES = ['image/png', 'image/jpg'].freeze
```

### File Organization

```ruby
# Good order for model contents:
class Story < ApplicationRecord
  # 1. Includes and extends
  include Publishable

  # 2. Constants
  MAX_TITLE_LENGTH = 200

  # 3. Associations
  has_one_attached :header_image

  # 4. Validations
  validates :title, presence: true
  validates :content, presence: true

  # 5. Scopes
  scope :recent, -> { order(created_at: :desc) }

  # 6. Callbacks
  before_save :sanitize_content

  # 7. Class methods
  def self.featured
    published.limit(5)
  end

  # 8. Instance methods
  def summary
    content.truncate(200)
  end

  # 9. Private methods
  private

  def sanitize_content
    # ...
  end
end
```

### Pattern Examples

See [.claude/skills/rails-guidelines/SKILL.md](../.claude/skills/rails-guidelines/SKILL.md) for detailed pattern guidance:

- Model patterns
- Controller patterns
- Service object patterns
- Testing patterns

## Testing Requirements

### Test Coverage

- **Target**: 90%+ coverage for new code
- **Required**: All new features must have tests
- **Run coverage**: `bin/docker rspec` then `open coverage/index.html`

### What to Test

**Models**:
- Validations
- Associations
- Scopes
- Business logic methods
- Edge cases

**Controllers**:
- Authentication requirements
- Authorization (admin vs regular user)
- Successful responses
- Error handling
- Parameter validation

**Requests**:
- Full HTTP request/response cycle
- Instance variable assignments
- Ordering and filtering
- Cache behavior

**Example model spec**:

```ruby
RSpec.describe Story do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
    it { should define_enum_for(:status).with_values(draft: 'draft', published: 'published') }
  end

  describe 'concerns' do
    it_behaves_like 'publishable'
  end

  describe '#summary' do
    it 'returns truncated content' do
      story = create(:story, content: 'A' * 300)
      expect(story.summary.length).to be <= 200
    end
  end
end
```

### Testing Tools

- **RSpec**: Test framework
- **FactoryBot**: Test data generation
- **Faker**: Realistic fake data
- **Shoulda Matchers**: Validation/association matchers
- **SimpleCov**: Coverage reporting

### Running Tests

```bash
# All tests
bin/docker rspec

# Specific file
bin/docker rspec spec/models/story_spec.rb

# Specific test
bin/docker rspec spec/models/story_spec.rb:15

# By tag
bin/docker rspec --tag focus
```

## Submitting Changes

### Pull Request Checklist

Before submitting a PR:

- [ ] All tests passing (`bin/docker rspec`)
- [ ] RuboCop passing (`bundle exec rubocop`)
- [ ] Brakeman passing (`bundle exec brakeman`)
- [ ] Test coverage maintained or improved
- [ ] Documentation updated (if needed)
- [ ] Issue updated in Beads
- [ ] Commit messages are clear
- [ ] PR description is complete

### PR Description Template

```markdown
## Summary
Brief description of what this PR does

## Related Issue
Closes Islam4Kids-abc

## Changes Made
- Added email validation to User model
- Updated user factory
- Added specs for edge cases

## Testing
- All existing tests pass
- Added 5 new specs covering:
  - Valid email formats
  - Invalid email formats
  - Nil email
  - Blank email
  - Duplicate email

## Screenshots (if applicable)
[Add screenshots for UI changes]

## Checklist
- [x] Tests passing
- [x] RuboCop passing
- [x] Documentation updated
- [x] Issue updated
```

### PR Size Guidelines

Keep PRs focused and reviewable:

- **Ideal**: < 200 lines of code
- **Maximum**: < 500 lines of code
- **Large changes**: Break into multiple PRs

If you have a large feature:
1. Create an epic issue in Beads
2. Break into smaller child tasks
3. Submit separate PRs for each task

## Issue Tracking with Beads

### Creating Issues

When you discover bugs, refactoring needs, or missing features:

```bash
# Bug found
bd create "Fix User validation to allow nil email" -t bug -p 1 -l models,bug

# Missing tests
bd create "Add specs for Publishable concern" -t task -p 2 -l tests,models

# Refactoring opportunity
bd create "Extract email sending to service object" -t chore -p 2 -l refactoring,services

# New feature idea
bd create "Add password strength requirements" -t feature -p 2 -l authentication
```

### Updating Issues

Track your progress:

```bash
# Starting work
bd update Islam4Kids-abc --status in_progress --assignee your-name

# Add notes
bd update Islam4Kids-abc --notes "Discovered validation needs to allow temporary nil"

# Closing
bd close Islam4Kids-abc --reason "Added validation with full test coverage, all specs passing"
```

### Issue Labels

Use consistent labels for filtering:

**Feature Areas**:
- `authentication`, `authorization`, `admin`, `content`, `api`

**Technical Areas**:
- `models`, `controllers`, `views`, `services`, `jobs`, `mailers`

**Quality**:
- `tests`, `refactoring`, `technical-debt`, `documentation`, `quality`

**Types**:
- `bug`, `feature`, `setup`, `migration`

**Difficulty**:
- `good-first-issue`, `help-wanted`

See [.claude/BEADS_CHEATSHEET.md](../.claude/BEADS_CHEATSHEET.md) for more commands.

## Code Review Process

### As a Contributor

When your PR is under review:

1. **Respond to feedback promptly**
2. **Ask questions if feedback is unclear**
3. **Make requested changes in new commits** (don't force push)
4. **Mark conversations as resolved** after addressing
5. **Request re-review** when ready

### As a Reviewer

When reviewing PRs:

1. **Check tests first**: Do they cover the changes?
2. **Run the code locally**: Does it work?
3. **Review for clarity**: Is the code readable?
4. **Check patterns**: Does it follow our conventions?
5. **Security**: Any vulnerabilities introduced?
6. **Performance**: Any N+1 queries or inefficiencies?

**Be constructive**:
- Suggest improvements, don't demand
- Explain *why* a change is needed
- Recognize good work
- Offer to pair on complex issues

## Common Patterns

### Adding a New Content Type

Follow the pattern of existing content types (Blog, Story, Printable, Game):

1. Generate model with migration
2. Include `Publishable` concern
3. Add file attachments (if needed)
4. Add validations
5. Create factory
6. Write model specs
7. Create controller in `Admin::` namespace
8. Add routes
9. Create views (index, show, new, edit, form)
10. Write controller specs
11. Update seeds (if applicable)

See existing models for reference.

### Adding a Service Object

Place service objects in [app/services/](../app/services/):

```ruby
# app/services/email_notifier.rb
class EmailNotifier
  def initialize(user)
    @user = user
  end

  def call
    # Service logic here
  end

  private

  attr_reader :user
end
```

Usage:

```ruby
EmailNotifier.new(user).call
```

### Adding a Background Job

Use Solid Queue (Rails 8 default):

```ruby
# app/jobs/email_job.rb
class EmailJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find(user_id)
    EmailNotifier.new(user).call
  end
end
```

Enqueue:

```ruby
EmailJob.perform_later(user.id)
```

## Security Considerations

### Never Commit

- **Credentials**: API keys, passwords, secrets
- **Master key**: `config/master.key`
- **Personal data**: Real user emails, names, etc.
- **.env files**: With real credentials

### Always

- Use strong parameters in controllers
- Validate and sanitize user input
- Run Brakeman before pushing
- Check for SQL injection vulnerabilities
- Validate file uploads (content type and size)

### Children's Safety

This application serves children. Extra care required:

- Moderate all user-generated content
- Sanitize rich text (when implemented)
- Validate all file uploads strictly
- Never expose personal information
- Implement COPPA compliance (if collecting data from children)

## Getting Help

### Documentation

- [Architecture](architecture.md) - System design
- [Setup Guide](setup.md) - Local development
- [Deployment](deployment.md) - AWS infrastructure
- [Rails Guidelines](.claude/skills/rails-guidelines/SKILL.md) - Coding patterns
- [Beads Cheatsheet](.claude/BEADS_CHEATSHEET.md) - Issue tracking

### Community

- **Issues**: Check [Beads issues](http://localhost:3000/admin/beads)
- **Discussions**: Open a GitHub discussion
- **Questions**: Ask in pull request comments

### External Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [Rails API](https://api.rubyonrails.org/)
- [RSpec Documentation](https://rspec.info/)
- [Beads Documentation](https://github.com/beadslabsio/beads)

## Code of Conduct

### Our Pledge

We pledge to make participation in this project a harassment-free experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Our Standards

**Positive behavior**:
- Using welcoming and inclusive language
- Being respectful of differing viewpoints
- Gracefully accepting constructive criticism
- Focusing on what is best for the community
- Showing empathy towards other community members

**Unacceptable behavior**:
- Trolling, insulting/derogatory comments, and personal attacks
- Public or private harassment
- Publishing others' private information
- Other conduct which could reasonably be considered inappropriate

### Enforcement

Instances of unacceptable behavior may be reported to the project maintainers. All complaints will be reviewed and investigated and will result in a response that is deemed necessary and appropriate to the circumstances.

## Recognition

Contributors will be recognized in:
- GitHub contributors list
- Release notes (for significant contributions)
- Project README (for ongoing contributors)

Thank you for contributing to Islam4Kids!
