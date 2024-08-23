using FluentValidation;

namespace API.Features.TodoItems.GetTodoItem;

public class GetTodoItemQueryValidator : AbstractValidator<GetTodoItemQuery>
{
    public GetTodoItemQueryValidator()
    {
        RuleFor(q => q.Id)
            .Must(id => id != Guid.Empty)
            .WithMessage("Id cannot be empty.");
    }
}
