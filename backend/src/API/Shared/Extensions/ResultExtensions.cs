using API.Shared.Result;

namespace API.Shared.Extensions;

public static class ResultExtensions
{
    public static IResult ProblemDetails<T>(this Result<T> result)
    {
        if (result.IsSuccess)
        {
            throw new InvalidOperationException();
        }

        return Results.Problem(
            title: GetTitle(result.Error),
            detail: GetDetail(result.Error),
            extensions: GetErrors(result.Error),
            statusCode: GetStatusCode(result.Error.Type));
    }

    #region Private methods

    private static string GetTitle(Error error)
    {
        return error.Type switch
        {
            ErrorType.NotFound or
            ErrorType.Conflict or
            ErrorType.Validation => error.Code,
            _ => "Server failure"
        };
    }

    private static string GetDetail(Error error)
    {
        return error.Type switch
        {
            ErrorType.NotFound or
            ErrorType.Conflict or
            ErrorType.Validation => error.Description,
            _ => "An unexpected error occured"
        };
    }

    private static Dictionary<string, object?> GetErrors(Error error)
    {
        var errors = new Dictionary<string, object?>();

        foreach (var item in error.Failures)
        {
            errors.Add(item.Key, item.Value);
        }

        return errors;
    }

    private static int GetStatusCode(ErrorType type)
    {
        return type switch
        {
            ErrorType.NotFound => StatusCodes.Status404NotFound,
            ErrorType.Conflict => StatusCodes.Status409Conflict,
            ErrorType.Validation => StatusCodes.Status400BadRequest,
            _ => StatusCodes.Status500InternalServerError
        };
    }

    #endregion
}
