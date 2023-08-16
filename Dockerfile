FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["aspdockerapi.csproj", "./"]
RUN dotnet restore "./aspdockerapi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "aspdockerapi.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "aspdockerapi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "aspdockerapi.dll"]
