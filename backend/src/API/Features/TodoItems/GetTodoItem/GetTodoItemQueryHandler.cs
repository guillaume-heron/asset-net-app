using API.Entities;
using API.Shared.Result;
using MediatR;

namespace API.Features.TodoItems.GetTodoItem;

internal sealed class GetTodoItemQueryHandler() : IRequestHandler<GetTodoItemQuery, Result<TodoItem>>
{
    public async Task<Result<TodoItem>> Handle(GetTodoItemQuery query, CancellationToken cancellationToken)
    {
        await Task.Delay(500, cancellationToken);

        return TodoItem.Create(
            "Complete .Net asset application",
            "Complete a sample application, that shows how to build and deploy infrastructure and" +
            " a containerized .Net web api in an Azure app Service via Terraform and Github Actions.",
            false);
    }
}
