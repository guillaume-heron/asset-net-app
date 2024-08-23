using API.Domain;
using API.Shared.Extensions;
using API.Shared.Result;
using FluentValidation;
using MediatR;

namespace API.Features.TodoItems.CreateTodoItem;

internal sealed class CreateTodoItemCommandHandler(IValidator<CreateTodoItemCommand> _validator) : IRequestHandler<CreateTodoItemCommand, Result<Guid>>
{
    public async Task<Result<Guid>> Handle(CreateTodoItemCommand command, CancellationToken cancellationToken)
    {
        await Task.Delay(500, cancellationToken);

        // Domain validation
        var validationResult = _validator.Validate(command);
        if (!validationResult.IsValid)
        {
            return Error.DomainValidation(
                code: "TodoItem.DomainValidationError",
                failures: validationResult.Errors.ToDictionary());
        }

        var todoItem = TodoItem.Create(
            command.Title,
            command.Description,
            command.IsComplete);

        return todoItem.Id;
    }
}
