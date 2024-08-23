using API.Features.TodoItems.CreateTodoItem;
using API.Features.TodoItems.GetTodoItem;

namespace API.Features.TodoItems;

public static class TodoItemsEndpoints
{
    public static void Register(this IEndpointRouteBuilder app)
    {
        var todoItems = app.MapGroup("todoitems")
            .WithTags("TodoItems")
            .WithOpenApi();

        GetTodoItemEndpoint.Add(todoItems);
        CreateTodoItemEndpoint.Add(todoItems);
    }
}
