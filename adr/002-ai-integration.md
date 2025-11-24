# ADR 2: AI Integration for Content Operations

## Status
Proposed

## Context
Islam4Kids is a solo-developed Rails educational platform with limited developer time. The primary bottleneck is content creation and optimization - writing articles, creating printables, generating SEO metadata, and writing alt text for images. AI integration has become increasingly prevalent in job postings, and practical experience building AI-powered features provides both immediate value to the project and career development benefits.

Current constraints:
- Single developer with finite time for both content creation and technical development
- Need for production-ready, maintainable code patterns
- Religious content requires human review for accuracy
- SEO optimization and accessibility (alt text) are time-consuming but important
- Project serves as both a practical application and learning platform for advanced Rails concepts

The goal is to leverage AI as a content operations tool that augments the developer's capabilities rather than replacing judgment, particularly for tasks where AI can generate drafts that undergo human review.

## Decision
Implement AI integration using Anthropic's Claude API, starting with two specific features:

### Phase 1: SEO Metadata Generation
Build an admin-only feature that generates SEO-optimized titles and meta descriptions for articles. The system will:
- Use service objects (e.g., `AI::MetadataGenerator`) following Rails patterns
- Generate multiple options (3 titles, 3 descriptions) for human selection
- Store suggestions in JSONB columns for review and editing
- Maintain strict character limits (60 for titles, 160 for descriptions)
- Include domain context (Islamic educational content for children) in prompts

### Phase 2: Alt Text Generation  
Integrate AI-powered alt text generation into the existing image processing pipeline. The system will:
- Analyze uploaded images using Claude's vision capabilities
- Generate descriptive alt text with awareness of the Islamic educational context
- Store as suggestions for review before final assignment
- Process during image optimization workflow to maintain efficiency

### Supporting Architecture
**Service Object Pattern**: Encapsulate AI interactions in dedicated service objects within an `AI` namespace, making them testable and maintainable.

**Prompt Engineering as Business Logic**: Treat prompts as code - version controlled, explicit about constraints, context-aware, and structured for consistent JSON responses.

**Error Handling**: Implement comprehensive error handling for API failures, timeouts, rate limits, and malformed responses with appropriate logging.

**Cost Tracking**: Log token usage and costs per feature in an `AiUsage` model to monitor spending and optimize prompts.

**Testing Strategy**: Use VCR to record/replay API responses, test structure and constraints rather than exact content, maintain fast test suite without API costs.

**Draft-Only Workflow**: For future content generation features, implement status-based workflows that prevent AI-generated content from being published without explicit human review.

## Consequences

### Positive
- **Immediate time savings**: SEO metadata generation reduces a 10-minute task to 30 seconds of review and selection
- **Improved accessibility**: Alt text generation ensures all images have descriptive text without manual effort
- **Production-ready patterns**: Service objects, error handling, and testing approaches are interview-ready examples of AI integration
- **Scalability**: Patterns established here extend naturally to future features (content review, printable generation, content adaptation)
- **Learning value**: Hands-on experience with prompt engineering, API integration, and AI-specific concerns (non-determinism, cost management)
- **Maintainability**: Clear separation of concerns, testable code, and explicit error handling
- **Cost efficiency**: Background operations with predictable, low costs (< $0.01 per article for metadata, negligible for alt text)

### Negative
- **API dependency**: Features require external API availability and introduce latency
- **Non-deterministic outputs**: Same input may produce different results, requiring human review
- **Ongoing costs**: Per-use pricing model requires monitoring and budget management
- **Additional complexity**: New service layer, error handling patterns, and testing approaches
- **Privacy considerations**: Content sent to third-party API (Anthropic)
- **Prompt maintenance**: Prompts require tuning and updates as requirements evolve

### Risks & Mitigations
- **Religious accuracy**: Mitigated by draft-only workflows and explicit prompts stating AI should flag concerns for human review rather than making judgments
- **Cost overruns**: Mitigated by usage tracking, reasonable token limits, and features that run on-demand rather than per-user
- **API failures**: Mitigated by comprehensive error handling, graceful degradation, and treating AI features as optional enhancements
- **Prompt injection**: Mitigated by treating all user content as untrusted, separating system instructions from user content in prompts

## Alternatives Considered

### Build Traditional Rule-Based Systems
**Rejected**: SEO optimization and alt text generation benefit from understanding context and meaning, which rule-based systems handle poorly. Development time to build equivalent functionality would exceed learning and implementing AI integration.

### Use Open-Source LLMs (Llama, Mistral)
**Rejected**: Would require additional infrastructure (hosting, scaling) and operational complexity. For a solo developer, managed API services provide better time-to-value ratio. Could revisit if costs become prohibitive.

### Multiple AI Providers (OpenAI + Anthropic)
**Rejected for initial implementation**: Adds complexity for marginal benefit. Single provider simplifies error handling, monitoring, and cost tracking. Could add provider abstraction layer later if needed.

### User-Facing AI Features (Chatbots, AI Tutors)
**Rejected**: Introduces per-user scaling costs, support burden, and complexity inappropriate for solo development. Focus on developer-facing tools that amplify limited development time.

### Pre-Built AI Libraries (Langchain Ruby)
**Rejected**: Ruby ecosystem for AI is immature compared to Python. Building directly against API provides better understanding of patterns and more control. Service objects provide sufficient abstraction.

## Notes
- Start with SEO generator as proof of concept - simpler, lower risk, immediate value
- Alt text integrates naturally into existing image processing work
- Future features (content review, printable generation) follow established patterns
- Decision to use Claude API specifically based on existing familiarity and good documentation
- Implementation timeline: Weekend for SEO generator, integrate alt text during next image optimization work