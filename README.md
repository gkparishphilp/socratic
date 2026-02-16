# Socratic

A survey and questionnaire engine for Rails with question management, response collection, scoring, and CSV export.

See [CLAUDE.md](CLAUDE.md) for detailed architecture documentation.

## Features

- Survey creation and management with FriendlyId slugs
- Multiple question UI types: text box, text area, radio buttons, checkbox, checkbox group, select, star rating, date, agree box
- Answer prompts with scoring and correctness tracking
- User survey sessions (surveyings) with progress tracking
- Batch response processing
- Deep clone support for surveys and questions
- CSV export with user profile data and checkbox group aggregation
- Polymorphic parent attachment for surveys
- Auto-incrementing question and prompt sequences

## Models

| Model | Description |
|-------|-------------|
| `Survey` | Survey definition with title, description, and time window |
| `Question` | Questions with configurable UI type, sequence, and validation |
| `Prompt` | Answer options/choices with scoring |
| `Surveying` | User's survey session/attempt with status tracking |
| `Response` | Individual answer to a question |

## Configuration

The engine uses `isolate_namespace Socratic` and requires minimal configuration.

```ruby
Socratic.configure do |config|
  # Configuration options available as needed
end
```

## Dependencies

- `rails` >= 5.2.0

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
