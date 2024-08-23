namespace API.Shared.Result;

public class Result<T>
{
    private Result(bool isSuccess, T? value, Error error)
    {
        IsSuccess = isSuccess;
        Error = error;
        Value = value;
    }

    private Result(bool isSuccess, Error error)
    {
        IsSuccess = isSuccess;
        Error = error;
    }

    public T? Value { get; } = default;

    public bool IsSuccess { get; }

    public bool IsFailure => !IsSuccess;

    public Error Error { get; }


    public static implicit operator Result<T>(T value) => new(true, value, Error.None);

    public static implicit operator Result<T>(Error error) => new(false, error);

    public Result<T> Match(Func<T, Result<T>> success, Func<Error, Result<T>> failure)
    {
        if (IsSuccess)
        {
            return success(Value!);
        }

        return failure(Error!);
    }
}
