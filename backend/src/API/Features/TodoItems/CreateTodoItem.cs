using API.Contracts;
using API.Domain;
using Microsoft.AspNetCore.Mvc;

namespace API.Features.TodoItems;

public static class CreateTodoItem
{
    internal record CreateTodoItemCommand(string Title, string Description, bool IsComplete);

    internal static async Task<Guid> Handle(CreateTodoItemCommand command, CancellationToken ct)
    {
        await Task.Delay(1000, ct);

        var todoItem = TodoItem.Create(
            command.Title,
            command.Description,
            command.IsComplete);

        return todoItem.Id;
    }

    public static void AddEndpoint(this RouteGroupBuilder group)
    {
        group.MapPost("", async ([FromBody] CreateTodoItemRequest request, CancellationToken ct) =>
        {
            var command = new CreateTodoItemCommand(
                request.Title,
                request.Description,
                request.IsComplete);

            var todoItemId = await Handle(command, ct);

            return Results.Created($"/todoitems/{todoItemId}", todoItemId);
        })
        .Produces(StatusCodes.Status201Created);
    }
}
