FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["HelloAspNetCore.csproj", "./"]
RUN dotnet restore "HelloAspNetCore.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "HelloAspNetCore.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "HelloAspNetCore.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HelloAspNetCore.dll"]
