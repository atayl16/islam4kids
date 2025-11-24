# Deployment

This document describes the AWS deployment infrastructure for Islam4Kids. As outlined in [ADR 002: AWS Deployment Strategy](../adr/002-aws-deployment-strategy.md), we're using a phased migration approach with AWS infrastructure.

> **Note**: This document will be built out as the AWS infrastructure is implemented. Current status: Planning phase.

## Deployment Strategy

### Phased Migration Approach

1. **Phase 1: MVP Development** (Current)
   - Complete all core features locally
   - Comprehensive test coverage
   - All content types implemented

2. **Phase 2: Staging Deployment**
   - Deploy to AWS staging subdomain (`new.islam4kids.com`)
   - Keep Wix site live at primary domain
   - Monitor performance and user feedback

3. **Phase 3: Parallel Run** (2-3 months)
   - Both sites running simultaneously
   - Validate SEO performance
   - Monitor traffic and errors

4. **Phase 4: Full Migration**
   - Implement comprehensive 301 redirects
   - Cut over primary domain to Rails app
   - Decommission Wix site

## Infrastructure Components

### Planned AWS Services

| Service | Purpose | Status |
|---------|---------|--------|
| **EC2 or ECS** | Application hosting (Docker-based) | Planned |
| **RDS PostgreSQL** | Managed database with automatic backups | Planned |
| **ElastiCache Redis** | Caching and session storage | Planned |
| **S3** | Static asset and file upload storage | Planned |
| **CloudFront** | CDN for global content delivery | Planned |
| **Route 53** | DNS management | Planned |
| **ACM** | SSL certificate management | Planned |
| **CloudWatch** | Infrastructure monitoring and logging | Planned |

### Additional Services

| Service | Purpose | Status |
|---------|---------|--------|
| **Sentry** | Error tracking and alerting | Planned |
| **SendGrid** | Transactional email delivery | Account configured |

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      CloudFront CDN                          │
│            (Global edge locations + SSL)                     │
└────────────┬────────────────────────────────────────────────┘
             │
             ├─────────────┐
             │             │
┌────────────▼──────┐  ┌──▼─────────────┐
│  S3 Bucket        │  │  Load Balancer │
│  (Static Assets)  │  │  (ALB)         │
└───────────────────┘  └──┬─────────────┘
                          │
              ┌───────────┴───────────┐
              │                       │
     ┌────────▼─────────┐    ┌───────▼────────┐
     │  ECS Service     │    │  ECS Service   │
     │  (Rails App)     │    │  (Rails App)   │
     └────────┬─────────┘    └───────┬────────┘
              │                      │
              └──────────┬───────────┘
                         │
         ┌───────────────┼───────────────┐
         │               │               │
    ┌────▼─────┐  ┌─────▼──────┐  ┌────▼──────┐
    │   RDS    │  │ ElastiCache│  │    S3     │
    │(PostgreSQL)│ │   (Redis)  │  │ (Uploads) │
    └──────────┘  └────────────┘  └───────────┘
```

## Environment Configuration

### Environment Variables

Required environment variables for production deployment:

```bash
# Rails
RAILS_ENV=production
RAILS_MASTER_KEY=<from config/master.key>

# Database
DATABASE_URL=postgresql://user:password@rds-endpoint:5432/islam4kids_production

# Redis
REDIS_URL=redis://elasticache-endpoint:6379/0

# AWS
AWS_ACCESS_KEY_ID=<iam-user-key>
AWS_SECRET_ACCESS_KEY=<iam-user-secret>
AWS_REGION=us-east-1
AWS_S3_BUCKET=islam4kids-uploads

# Email
SENDGRID_API_KEY=<sendgrid-api-key>
SENDGRID_DOMAIN=islam4kids.org

# Monitoring
SENTRY_DSN=<sentry-project-dsn>

# Application
DOMAIN=islam4kids.org
PROTOCOL=https
```

### Secrets Management

Production secrets will be managed using:
- **Rails Credentials**: Application secrets encrypted with master key
- **AWS Secrets Manager**: Database credentials and API keys
- **Environment Variables**: Service endpoints and configuration

## Deployment Process

### Initial Deployment

> **Status**: To be implemented

Planned deployment steps:

1. **Provision AWS Infrastructure**
   ```bash
   # Using Terraform or AWS CLI
   # Configure VPC, subnets, security groups
   # Provision RDS, ElastiCache, S3 buckets
   # Set up ECS cluster and task definitions
   ```

2. **Build and Push Docker Image**
   ```bash
   docker build -t islam4kids:latest .
   aws ecr get-login-password | docker login --username AWS --password-stdin
   docker tag islam4kids:latest <ecr-repo-url>:latest
   docker push <ecr-repo-url>:latest
   ```

3. **Run Database Migrations**
   ```bash
   # Via ECS one-off task
   aws ecs run-task --task-definition islam4kids-migrate
   ```

4. **Deploy Application**
   ```bash
   # Update ECS service with new task definition
   aws ecs update-service --service islam4kids --force-new-deployment
   ```

5. **Verify Deployment**
   ```bash
   curl https://new.islam4kids.org/up
   ```

### Continuous Deployment

Planned CI/CD pipeline:

1. **Push to GitHub**
   - Trigger GitHub Actions workflow

2. **Run Tests**
   - RSpec test suite
   - RuboCop linting
   - Brakeman security scan

3. **Build Docker Image**
   - Build production image
   - Push to Amazon ECR

4. **Deploy to Staging**
   - Update ECS staging service
   - Run smoke tests

5. **Manual Production Deploy** (initially)
   - Require manual approval
   - Deploy to production ECS service
   - Monitor error rates in Sentry

## Database Management

### Backups

RDS automated backups:
- Daily automated snapshots
- 7-day retention period (adjustable)
- Point-in-time recovery available

Manual backups before major changes:
```bash
aws rds create-db-snapshot \
  --db-instance-identifier islam4kids-prod \
  --db-snapshot-identifier islam4kids-pre-migration-2024-11-19
```

### Migrations

Production migration process:
1. Test migration in staging environment
2. Create database backup
3. Run migration via ECS task
4. Verify application health
5. Monitor error logs

### Database Scaling

Initial size: db.t4g.micro (2 vCPU, 1GB RAM)

Scale up if needed:
- db.t4g.small (2 vCPU, 2GB RAM)
- db.t4g.medium (2 vCPU, 4GB RAM)

Monitor via CloudWatch:
- CPU utilization
- Database connections
- Read/write latency

## Monitoring and Observability

### Application Monitoring (Sentry)

Error tracking and performance monitoring:
- Exception tracking with full stack traces
- Performance transaction monitoring
- Release tracking for deployments
- Email/Slack alerts for critical errors

### Infrastructure Monitoring (CloudWatch)

Key metrics to track:
- **ECS**: CPU/memory utilization, task health
- **RDS**: Connection count, query performance, storage
- **ElastiCache**: Hit rate, CPU, evictions
- **ALB**: Request count, latency, error rates

Alarms for:
- High CPU (>80% for 5 minutes)
- High memory (>90%)
- Database storage (>85% full)
- Error rate spike (>1% of requests)

### Logging

Centralized logging via CloudWatch Logs:
- Application logs (Rails logger)
- Web server logs (Puma)
- Database slow queries
- ECS container logs

Log retention: 30 days (adjustable)

## Cost Optimization

### Estimated Monthly Costs

| Service | Configuration | Est. Cost |
|---------|--------------|-----------|
| ECS (2 tasks) | Fargate 0.5 vCPU, 1GB | $15-20 |
| RDS | db.t4g.micro | $15-20 |
| ElastiCache | cache.t4g.micro | $10-12 |
| S3 + CloudFront | 50GB storage, 500GB transfer | $5-10 |
| **Total** | | **$45-62/month** |

Additional costs during parallel run:
- Both Wix ($12.50/month) and AWS running
- Total: $57-74/month for 2-3 months

### Cost Reduction Strategies

1. **Right-size resources after monitoring**
   - Start small, scale based on actual usage
   - Review CloudWatch metrics monthly

2. **Reserved capacity** (after 6+ months)
   - 1-year reserved instances for predictable workloads
   - 30-40% cost savings

3. **S3 lifecycle policies**
   - Move old uploads to S3 Glacier after 90 days
   - Delete temporary files after 7 days

4. **CloudFront caching**
   - Aggressive caching reduces origin requests
   - Lower data transfer costs

## Security

### Network Security

- VPC with public and private subnets
- Security groups: Least privilege access
- RDS and ElastiCache in private subnets
- Application load balancer in public subnet

### Application Security

- SSL/TLS via ACM (free certificates)
- HTTPS only (redirect HTTP → HTTPS)
- Security headers (HSTS, CSP, X-Frame-Options)
- Regular dependency updates via Dependabot

### Access Control

- IAM roles for ECS tasks (no hardcoded credentials)
- Separate IAM users for developers (MFA required)
- CloudTrail for audit logging
- Secrets in AWS Secrets Manager (not environment variables)

## Rollback Strategy

### Application Rollback

If deployment fails:

```bash
# Revert to previous ECS task definition
aws ecs update-service \
  --service islam4kids \
  --task-definition islam4kids:PREVIOUS_VERSION
```

### Database Rollback

If migration causes issues:

1. Run rollback migration (if available)
2. Restore from RDS snapshot (if necessary)
3. Update application to previous version

Always test rollback procedures in staging.

## Disaster Recovery

### RTO/RPO Targets

- **Recovery Time Objective (RTO)**: 1 hour
- **Recovery Point Objective (RPO)**: 1 hour (RDS automated backups)

### Backup Strategy

1. **Database**: Automated RDS snapshots (daily)
2. **Uploads**: S3 versioning enabled
3. **Application Code**: Git repository (GitHub)
4. **Infrastructure**: Terraform state (to be implemented)

### Recovery Procedures

1. **Database failure**: Restore from latest RDS snapshot
2. **Application failure**: Deploy previous working version
3. **Region failure**: Manual failover to different region (future)

## Maintenance Windows

Planned maintenance: Sundays 2-4 AM UTC (lowest traffic)

Maintenance activities:
- Database updates and patches
- ECS task definition updates
- Security updates
- Performance optimizations

## Performance Targets

Based on current Wix site performance, targets:

- **Page Load Time**: < 2 seconds (3G, mobile)
- **Time to First Byte**: < 500ms
- **Lighthouse Score**: > 90
- **Uptime**: 99.9% (< 45 minutes downtime/month)

Monitor via:
- Sentry performance monitoring
- CloudWatch RUM (Real User Monitoring)
- Synthetic checks from multiple regions

## Migration Checklist

### Pre-Migration

- [ ] All features implemented and tested
- [ ] Performance testing completed
- [ ] Security audit passed
- [ ] SSL certificates configured
- [ ] DNS records prepared
- [ ] 301 redirects mapped
- [ ] Backup strategy tested

### Migration Day

- [ ] Create final Wix backup
- [ ] Deploy to production
- [ ] Update DNS records
- [ ] Monitor error rates
- [ ] Verify SEO redirects
- [ ] Test critical user flows

### Post-Migration

- [ ] Monitor traffic patterns (7 days)
- [ ] Check search console for crawl errors
- [ ] Verify email delivery
- [ ] Review performance metrics
- [ ] Optimize based on real data

## Future Improvements

- Multi-region deployment for global performance
- Auto-scaling based on traffic patterns
- Blue-green deployments for zero-downtime releases
- Infrastructure as Code (Terraform)
- Advanced caching strategies (HTTP caching, fragment caching)

## Support and Troubleshooting

### Common Issues

**Application won't start**
- Check ECS task logs in CloudWatch
- Verify environment variables
- Check security group rules

**Database connection errors**
- Verify RDS security group allows ECS
- Check database credentials
- Confirm database is running

**High latency**
- Check CloudFront cache hit rate
- Review database slow query log
- Monitor ECS CPU/memory utilization

### Getting Help

- **AWS Support**: Basic support plan included
- **Documentation**: AWS documentation and guides
- **Community**: Rails deployment forums
- **Monitoring**: Check Sentry for application errors

## Related Documentation

- [ADR 002: AWS Deployment Strategy](../adr/002-aws-deployment-strategy.md)
- [Architecture Documentation](architecture.md)
- [Setup Guide](setup.md)
- [Contributing Guide](contributing.md)
