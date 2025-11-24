# ADR 001: AWS Deployment Strategy and Phased Migration Approach

**Date:** 2024-11-17

**Status:** Accepted

## Context

Islam4Kids is currently hosted on Wix (~$150/year) and receives approximately 2,500 sessions per week (~10,000 sessions/month), primarily from Google search traffic. The site serves educational Islamic content to children and families globally, with traffic coming from users on various devices and connection speeds.

I'm rebuilding the site in Rails 8 to gain full control over content management, image optimization, page load speeds, and overall user experience. This is both a production application serving real users and a learning project to develop senior-level Rails and infrastructure skills.

## Decision

We will deploy to AWS infrastructure with a phased migration approach:

### Infrastructure Components:
- **Hosting**: EC2 or ECS (Docker-based, leveraging existing local Docker setup)
- **Database**: RDS PostgreSQL (managed service for automatic backups and easier maintenance)
- **Caching**: ElastiCache Redis for session storage and caching
- **Assets**: S3 + CloudFront (already planned for image optimization)
- **Monitoring**: Sentry for error tracking, CloudWatch for infrastructure metrics
- **Email**: SendGrid (account already configured)

### Migration Strategy:
1. Build complete MVP in Rails with all core features (stories, blogs, games, videos, printables)
2. Deploy to staging subdomain (e.g., `new.islam4kids.com`) while keeping Wix live
3. Run both sites in parallel for 2-3 months
4. Monitor staging site performance, SEO indexing, and user feedback
5. Perform full migration with comprehensive 301 redirects once confident in new site performance

### Timeline:
- MVP features: ~6 months (building while job searching)
- Parallel run: 2-3 months
- Full migration: After gaining employment and validating staging performance

## Alternatives Considered

### Platform as a Service (Heroku, Render, Fly.io)
**Pros:**
- Simpler deployment (~$25-45/month total)
- Less DevOps overhead
- Faster to get running

**Cons:**
- Less learning value for senior Rails positions
- Higher cost for equivalent resources
- Limited infrastructure control
- Doesn't develop AWS skills valued in job market

**Decision:** Rejected. The learning value of AWS infrastructure outweighs the convenience of PaaS, especially since this is explicitly a learning project.

### Immediate Migration (Cut Over from Wix)
**Pros:**
- Faster completion
- Single source of truth immediately
- No dual maintenance period

**Cons:**
- High risk to existing SEO and traffic
- No rollback strategy if problems arise
- Pressure to fix issues quickly affects users
- No validation period for performance

**Decision:** Rejected. User safety and experience are paramount. The cost of running both systems for 2-3 months ($30-50/month) is worth the risk reduction.

### Self-Hosted VPS (DigitalOcean, Hetzner)
**Pros:**
- Lowest cost option ($5-10/month)
- Full control

**Cons:**
- Most DevOps overhead (security updates, backups, monitoring)
- Single point of failure
- Time-intensive during job search period
- Doesn't teach managed service patterns used in production

**Decision:** Rejected. While cost-effective, the operational burden is too high given current job search priorities, and managed services (RDS, ElastiCache) better reflect production environments at companies I'm targeting.

## Consequences

### Positive:
- Deep understanding of AWS infrastructure valuable for senior Rails interviews
- Low-risk migration protects existing user base and SEO rankings
- Staging environment provides real-world performance data before full migration
- Scalable infrastructure that can grow with the site
- Docker setup positions well for ECS deployment
- Existing AWS account (with S3) removes account approval delays
- Managed services (RDS, ElastiCache) reduce operational burden

### Negative:
- Higher monthly cost: ~$30-50/month vs $12.50/month current Wix cost (2-4x increase)
- More complex deployment and maintenance than PaaS
- Dual-running cost during 2-3 month parallel period
- Requires learning AWS infrastructure alongside Rails development
- Potential for DevOps work to distract from MVP feature completion

### Mitigation Strategies:
- Complete all MVP features before starting infrastructure work to avoid context-switching
- Delay production migration until after employment to manage costs
- Document infrastructure setup as it's built for future reference and contributor onboarding
- Use staging period to optimize costs and right-size resources

## Notes

Traffic data shows steady growth over years, indicating healthy organic search presence. Primary concern is maintaining this SEO performance through migration, which the phased approach directly addresses.

This decision supports multiple goals:
1. **User Experience**: Better performance, control, and content management
2. **Learning**: Senior-level Rails patterns and AWS infrastructure skills
3. **Career Development**: Portfolio piece demonstrating systems thinking and production operations
4. **Open Source**: Clear infrastructure documentation enables others to deploy similar Rails applications

The 6-month timeline for MVP development aligns with current job search, allowing focused interview preparation while making steady project progress.
