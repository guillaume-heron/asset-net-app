using API.Contracts;
using API.Shared.Extensions;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace API.Features.TodoItems.CreateTodoItem;

public static class CreateTodoItemEndpoint
{
    public static void Add(this RouteGroupBuilder group)
    {
        group.MapPost("", async (
            [FromBody] CreateTodoItemRequest request,
            [FromServices] ISender sender,
            CancellationToken cancellationToken) =>
        {
            var command = new CreateTodoItemCommand(
                request.Title,
                request.Description,
                request.IsComplete);

            var result = await sender.Send(command, cancellationToken);

            if (result.IsFailure)
            {
                return result.ProblemDetails();
            }

            return TypedResults.Created($"/todoitems/{result.Value}", result.Value);
        })
        .Produces(StatusCodes.Status201Created);
    }
}
