using API.Shared.Extensions;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace API.Features.TodoItems.GetTodoItem;

public static class GetTodoItemEndpoint
{
    public static void Add(this RouteGroupBuilder group)
    {
        group.MapGet("{id}", async (Guid id, [FromServices] ISender sender) =>
        {
            var result = await sender.Send(new GetTodoItemQuery(id));

            if (result.IsFailure)
            {
                return result.ProblemDetails();
            }

            return Results.Ok(result.Value);
        })
        .Produces(StatusCodes.Status200OK);
    }
}
