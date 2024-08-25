using API.Contracts.Requests.CreateTodoItem;
using API.Contracts.Results;
using API.Shared.Extensions;
using API.Shared.Result;
using FluentValidation;
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
            [FromServices] IValidator<CreateTodoItemRequest> validator,
            CancellationToken cancellationToken) =>
        {
            // Input validation
            var validationResult = validator.Validate(request);
            if (!validationResult.IsValid)
            {
                var error = Error.InputValidation(
                    code: "TodoItem.InputValidationError",
                    failures: validationResult.Errors.ToDictionary());

                return FailureResults.Problem(error);
            }

            var command = new CreateTodoItemCommand(
                request.Title,
                request.Description,
                request.IsComplete);

            var result = await sender.Send(command, cancellationToken);
            if (result.IsFailure)
            {
                return FailureResults.Problem(result);
            }

            return TypedResults.Created($"/todoitems/{result.Value}", result.Value);
        })
        .Produces(StatusCodes.Status201Created);
    }
}
