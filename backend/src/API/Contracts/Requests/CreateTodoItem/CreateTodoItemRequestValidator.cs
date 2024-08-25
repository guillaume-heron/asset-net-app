using FluentValidation;

namespace API.Contracts.Requests.CreateTodoItem;

public sealed class CreateTodoItemRequestValidator : AbstractValidator<CreateTodoItemRequest>
{
    private const short NameFieldMinimumLength = 2;

    public CreateTodoItemRequestValidator()
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
