## Islam4Kids Roadmap

| Phase | Focus | Status | Notes |
| --- | --- | --- | --- |
| 1A | Core models, authentication, publishable patterns | ✅ Complete | Foundation ready |
| 1B | Admin/public controllers & views | ✅ Complete | CRUD & auth flow solid |
| 1C | Homepage, navigation, static pages | ✅ Complete | Tailwind + layouts |
| 1G | UI polish across app | ✅ Complete | Responsive styling |
| 1D | Local storage & uploads | ✅ Complete | Active Storage wired (S3 deferred) |
| 1E | Testing, CI, quality checks | ✅ Complete | Suite + scans_green |
| 1E+ | Caching layer | ✅ Complete | Redis caching live |
| 1F | Content parity (printables, games, videos, polish) | 🚧 In progress | Feature build-out |
| 1H | Database & deployment prep | ⏳ Planned | PostgreSQL, S3, AWS |
| 2 | Post-MVP enhancements | 🌤️ Future | Feature backlog |
| 3 | AI content assistance | 🌤️ Future | SEO, alt text, grammar |

### Parallel Track: Image Optimization
1. Local processing pipeline (`HasHeaderImage`, `ImagePreprocessor`, helper)
2. S3 + CloudFront configuration
3. Migration, accessibility pass, performance audits

### Phase 3: AI Content Assistance (Future)

**Prerequisites**: MVP deployed, stable content workflow, budget allocated

**Features** (in implementation order):
1. **SEO Metadata Generator** - AI-generated title & description options
2. **Alt Text Generator** - Accessibility-friendly image descriptions
3. **Grammar & Clarity Checker** - Content review assistance
4. **Content Draft Generator** - Initial draft creation with mandatory review

**Implementation Timeline**: 3-4 weekends after post-MVP stabilization

**Cost**: ~$0.66/month for typical usage (~$5-10/month budgeted)

**Learning Goals**: API integration, prompt engineering, service objects, JSONB storage, VCR testing

**Documentation**: [docs/ai-features.md](docs/ai-features.md)

**Safety**: All AI content requires human review before publication, especially for religious accuracy

