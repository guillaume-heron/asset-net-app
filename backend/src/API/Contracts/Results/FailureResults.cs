using API.Shared.Result;

namespace API.Contracts.Results;

public static class FailureResults
{
    public static IResult Problem<T>(Result<T> result)
    {
        if (result.IsSuccess)
        {
            throw new InvalidOperationException();
        }

        return Problem(result.Error);
    }

    public static IResult Problem(Error error)
    {
        return TypedResults.Problem(
            title: GetTitle(error),
            detail: GetDetail(error),
            extensions: GetErrors(error),
            statusCode: GetStatusCode(error));
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

    private static int GetStatusCode(Error error)
    {
        return error.Type switch
        {
            ErrorType.NotFound => StatusCodes.Status404NotFound,
            ErrorType.Conflict => StatusCodes.Status409Conflict,
            ErrorType.Validation => StatusCodes.Status400BadRequest,
            _ => StatusCodes.Status500InternalServerError
        };
    }

    #endregion
}
