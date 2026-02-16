# CLAUDE.md - Socratic Engine

## Purpose

Socratic is a survey/questionnaire engine providing survey creation, question management, response collection, scoring, and CSV export. It supports multiple question UI types and batch response processing.

**Version:** 4.0.3

## Key Models

### Socratic::Survey

- `enum status`: `draft: 0`, `active: 1`, `archive: 3`, `trash: 9`
- **Associations**: `has_many :questions, dependent: :destroy`, `has_many :surveyings, dependent: :destroy`
- **FriendlyId** slugged with history
- **Key attributes**: title, description, survey_type, preface, thank_you_copy, template, layout, starts_at, ends_at, require_login, ttl
- **Polymorphic parent**: parent_obj_id, parent_obj_type
- **Key method**: `clone!(args)` - Deep clones survey with all questions and prompts

### Socratic::Question

- **Associations**: `belongs_to :survey`, `has_many :prompts, dependent: :destroy`, `has_many :responses, dependent: :destroy`
- **FriendlyId** slugged, scoped to survey
- **Key attributes**: title, data_label, content, preface, question_ui (default: 'text_box'), seq, is_required, question_style, question_classes, question_group, bind_data_field, default_prompt
- **Available UIs**: text_box, text_area, radio_buttons, check_box, check_box_group, select, star_rating, date, agree_box
- **Key method**: `clone!(args)` - Clones question with all prompts
- Auto-increments `seq` on creation

### Socratic::Prompt

Answer options/choices for a question.

- `belongs_to :question`
- **Key attributes**: title, content, seq, score (default: 0), is_correct, prompt_type (default: 'text')
- Auto-populates content from title if not provided

### Socratic::Surveying

A user's survey session/attempt.

- `enum status`: `trash: -10`, `draft: 0`, `active: 1`, `complete: 3`
- **Associations**: `belongs_to :survey`, `belongs_to :user`, `has_many :responses, dependent: :destroy`
- **Accepts**: `accepts_nested_attributes_for :responses`
- **Key attributes**: current_question_id, furthest_question_id, score, notes, completed_at
- **Key method**: `responses_hash` - Returns hash mapping question names to response content

### Socratic::Response

Individual answer to a question within a surveying.

- **Associations**: `belongs_to :surveying`, `belongs_to :question`, `belongs_to :prompt` (optional), `belongs_to :user` (optional)
- **Key attributes**: content, score, notes, started_at, completed_at
- Auto-populates content and score from prompt if present

## Controllers

### Admin

- **`SurveyAdminController`** - CRUD with clone and responses export
  - `responses` action: CSV export with user profile data (gender, DOB, address, phone, height, weight)
  - Supports result modes: content, score, both
  - Uses raw SQL with STRING_AGG for checkbox group aggregation

- **`QuestionAdminController`** - CRUD with clone
- **`PromptAdminController`** - CRUD (auto-increments seq)
- **`SurveyingAdminController`** - Show/destroy

### Public

- **`ResponsesController`** - `create` (single response), `save_batch` (batch response processing)
  - Creates or finds user by email
  - Creates or finds surveying for user+survey
  - Validates required questions answered
  - Supports FriendlyId slug lookup for questions

## Configuration

```ruby
Socratic.configure do |config|
  # Minimal configuration - mostly uses defaults
end
```

The engine is isolated: `isolate_namespace Socratic`

## Dependencies

- `rails` >= 5.2.0

Note: FriendlyId and Kaminari are used but not declared in gemspec (expected from host app).

## Database Tables

- `socratic_surveys` - Survey definitions with polymorphic parent
- `socratic_questions` - Questions with UI type, sequence, data_label
- `socratic_prompts` - Answer options with scoring
- `socratic_surveyings` - User survey sessions with status tracking
- `socratic_responses` - Individual answers with optional prompt reference

## Key Patterns

1. **Deep Cloning** - Surveys and questions support full deep-clone with nested associations
2. **Batch Response Processing** - `save_batch` handles multiple responses in a single request
3. **FriendlyId Scoped Slugs** - Questions slugged within survey scope
4. **Polymorphic Surveys** - Surveys can be attached to any parent object
5. **CSV Export** - Complex export with user profile data and checkbox group aggregation
