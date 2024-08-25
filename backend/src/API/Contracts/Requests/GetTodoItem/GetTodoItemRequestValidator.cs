using FluentValidation;

namespace API.Contracts.Requests.GetTodoItem;

public sealed class GetTodoItemRequestValidator : AbstractValidator<Guid>
{
    public GetTodoItemRequestValidator()
    {
        RuleFor(id => id)
            .Must(id => id != Guid.Empty)
            .WithMessage("Id cannot be empty.");
    }
}