using API.Shared.Result;
using MediatR;

namespace API.Features.TodoItems.CreateTodoItem;

public record CreateTodoItemCommand(
    string Title,
    string Description,
    bool IsComplete)
    : IRequest<Result<Guid>>;
