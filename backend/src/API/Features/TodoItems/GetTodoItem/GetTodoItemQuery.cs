using API.Entities;
using API.Shared.Result;
using MediatR;

namespace API.Features.TodoItems.GetTodoItem;

public record GetTodoItemQuery(Guid Id) : IRequest<Result<TodoItem>>;
