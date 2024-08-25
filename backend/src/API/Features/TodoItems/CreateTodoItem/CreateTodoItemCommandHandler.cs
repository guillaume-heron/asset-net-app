using API.Entities;
using API.Shared.Result;
using MediatR;

namespace API.Features.TodoItems.CreateTodoItem;

internal sealed class CreateTodoItemCommandHandler() : IRequestHandler<CreateTodoItemCommand, Result<Guid>>
{
    public async Task<Result<Guid>> Handle(CreateTodoItemCommand command, CancellationToken cancellationToken)
    {
        await Task.Delay(500, cancellationToken);

        var todoItem = TodoItem.Create(
            command.Title,
            command.Description,
            command.IsComplete);

        return todoItem.Id;
    }
}
