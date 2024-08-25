namespace API.Contracts.Requests.CreateTodoItem;

public record CreateTodoItemRequest(string Title, string Description, bool IsComplete);
