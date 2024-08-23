using FluentValidation;

namespace API.Features.TodoItems.CreateTodoItem;

public class CreateTodoItemCommandValidator : AbstractValidator<CreateTodoItemCommand>
{
    private const short NameFieldMinimumLength = 2;

    public CreateTodoItemCommandValidator()
    {
        RuleFor(c => c.Title)
            .NotEmpty()
            .WithMessage("Title is required.")
            .DependentRules(() =>
            {
                RuleFor(c => c.Title)
                    .Must(name => name.Length >= NameFieldMinimumLength)
                    .WithMessage($"Title must contain at least {NameFieldMinimumLength} characters.");
            });
    }
}
