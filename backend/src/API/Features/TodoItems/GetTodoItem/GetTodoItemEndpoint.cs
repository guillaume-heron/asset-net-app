using API.Contracts.Results;
using API.Shared.Extensions;
using API.Shared.Result;
using FluentValidation;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace API.Features.TodoItems.GetTodoItem;

public static class GetTodoItemEndpoint
{
    public static void Add(this RouteGroupBuilder group)
    {
        group.MapGet("{id}", async (
            Guid id,
            [FromServices] ISender sender,
            [FromServices] IValidator<Guid> validator,
            CancellationToken cancellationToken) =>
        {
            // Input validation
            var validationResult = validator.Validate(id);
            if (!validationResult.IsValid)
            {
                var error = Error.InputValidation(
                    code: "TodoItem.InputValidationError",
                    failures: validationResult.Errors.ToDictionary());

                return FailureResults.Problem(error);
            }

            var result = await sender.Send(new GetTodoItemQuery(id), cancellationToken);
            if (result.IsFailure)
            {
                return FailureResults.Problem(result);
            }

            return Results.Ok(result.Value);
        })
        .Produces(StatusCodes.Status200OK);
    }
}
