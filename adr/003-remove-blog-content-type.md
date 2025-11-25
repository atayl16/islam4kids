# ADR 003: Remove Blog Content Type from Rails Rebuild

**Date:** 2024-11-26

**Status:** Accepted

## Context

Islam4Kids currently has five main content types on the Wix platform: stories, games, printables, videos, and blog posts. During the Rails rebuild planning, we need to decide which content types to implement in the MVP, considering both user value and development effort.

Traffic data from the past year shows the site receives approximately 2,500 sessions per week (~10,000 sessions/month), primarily from Google search traffic. The site serves educational Islamic content to children and families globally.

Development time is constrained, making prioritization critical based on actual user engagement data.

## Decision

We will **remove the blog content type** from the Rails rebuild and focus exclusively on kid-focused educational content: stories, games, printables, and videos.

## Traffic Analysis

Annual traffic data reveals a clear hierarchy of content engagement:

**High-performing content:**
- `/stories`: 22,051 sessions, 18,365 unique visitors
- `/games`: 13,259 sessions, 10,054 unique visitors
- `/salat-beginner`: 11,051 sessions, 8,573 unique visitors
- `/pillars-of-islam`: 10,855 sessions, 8,034 unique visitors
- Individual story pages: 1,500-2,000 sessions each
- `/free-printables`: 4,500 sessions, 4,061 unique visitors
- `/videos`: 3,162 sessions, 2,394 unique visitors

**Low-performing content:**
- `/blog`: 335 sessions, 288 unique visitors (index page)
- Top blog post: 332 sessions, 301 unique visitors
- Most blog posts: 100-200 sessions annually
- Many blog posts: Under 100 sessions annually

The blog represents less than 2% of site traffic while requiring substantial development effort for CMS features like categories, tags, search, and rich text editing.

## Alternatives Considered

### Keep Blog as Planned Fifth Content Type
**Pros:**
- Maintains parity with current Wix site
- Provides avenue for parent-focused content
- Allows announcements and updates

**Cons:**
- Requires significant development time (admin interface, rich text editor, categories, search)
- Traffic data shows minimal user engagement
- Diverts resources from high-performing content types
- Blog-specific features (comments, categories, RSS) add complexity for minimal value

**Decision:** Rejected. The development cost vastly outweighs the user value based on traffic data.

### Convert Blog to Static "Parent Resources" Section
**Pros:**
- Simpler implementation (static pages or minimal CMS)
- Preserves utility content like resource roundups
- Much faster to build

**Cons:**
- Still requires some development time
- Most blog traffic is already minimal
- Can be added post-MVP if needed

**Decision:** Deferred. This can be reconsidered after MVP launch if parent-focused content proves necessary. Current data doesn't justify even a simplified version in MVP.

### Replace Blog with Interactive Courses
**Pros:**
- Traffic shows interest in `/courses` (955 sessions)
- Aligns with educational mission
- Differentiates from typical Islamic education sites
- Higher engagement potential than passive blog content

**Cons:**
- More complex to build than blog
- Requires different content creation workflow
- Needs learning management features

**Decision:** Considered for post-MVP enhancement. The traffic data and educational value make this a better investment than a blog, but it should come after core content types are solid.

## Consequences

### Positive:
- Development time focused on proven high-traffic content types
- Simpler CMS architecture without blog-specific features
- Faster path to MVP completion
- Resources directed toward content that serves primary audience (children) rather than secondary audience (parents)
- Reduced testing surface area
- Less content to migrate from Wix platform

### Negative:
- Loss of parent-focused content channel
- No built-in way to make announcements or share updates
- Some existing blog traffic will be lost (though minimal)
- Reduces content variety on the site

### Mitigation Strategies:
- Create simple "Updates" or "News" static page for announcements if needed
- Focus on strengthening the high-performing content types with better organization and discovery
- Consider simple parent resources section post-MVP if user feedback indicates need
- Use social media or email newsletter for updates instead of blog
- The few blog posts with decent traffic (resource roundups) can be converted to static pages or integrated into relevant sections

## Implementation Notes

This decision affects the Rails rebuild in several ways:

1. **Models:** Only need Story, Game, Printable, Video models with Publishable concern. No Blog model needed.

2. **Admin Interface:** One fewer content type to build CRUD operations for, saving development time on forms, validations, and preview functionality.

3. **Public Routes:** Simpler routing structure without blog categories, tags, or search functionality.

4. **Content Migration:** Eliminates need to migrate blog posts from Wix, reducing migration complexity and data cleanup work.

5. **SEO Considerations:** The 335 annual sessions to `/blog` index and minimal individual post traffic means SEO impact is negligible. The blog posts that do get traffic can have 301 redirects to relevant story or game pages where appropriate.

## Review Criteria

This decision should be reviewed if:
- User feedback explicitly requests parent-focused educational content
- Traffic patterns change significantly post-migration
- Partnership or community features require a content publishing platform
- The core four content types are complete and there's capacity for additional features

For now, the data clearly indicates that development resources should focus on stories, games, printables, and videos - the content that actually serves our users.
