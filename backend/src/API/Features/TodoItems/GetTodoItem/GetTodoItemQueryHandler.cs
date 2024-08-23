using API.Domain;
using API.Shared.Extensions;
using API.Shared.Result;
using FluentValidation;
using MediatR;

namespace API.Features.TodoItems.GetTodoItem;

internal sealed class GetTodoItemQueryHandler(IValidator<GetTodoItemQuery> _validator) : IRequestHandler<GetTodoItemQuery, Result<TodoItem>>
{
    public async Task<Result<TodoItem>> Handle(GetTodoItemQuery query, CancellationToken cancellationToken)
    {
        await Task.Delay(500, cancellationToken);

        // Domain validation
        var validationResult = _validator.Validate(query);
        if (!validationResult.IsValid)
        {
            return Error.DomainValidation(
                code: "TodoItem.DomainValidationError",
                failures: validationResult.Errors.ToDictionary());
        }

        return TodoItem.Create(
            "Complete .Net asset application",
            "Complete a sample application, that shows how to build and deploy infrastructure and" +
            " a containerized .Net web api in an Azure app Service via Terraform and Github Actions.",
            false);
    }
}
