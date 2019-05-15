var app = angular.module('App', []);

app.controller('PackagesController', function ($scope, $http) {
    
    // client methods
    
    $scope.packages_list = function () {
        $http({
            method: 'GET',
            url: 'http://localhost:8080/packages'
        }).then(function (response) {
            $scope.clients_packages = response.data.packages;
        });
    }


    $scope.package_register = function () {
        $http({
            method: 'POST',
            url: 'http://localhost:8080/packages',
            data: $scope.package,
        }).then(function (response) {
            $scope.packages_list();
        });
    }


    $scope.package_cancel = function () {
        $http({
            method: 'DELETE',
            url: 'http://localhost:8080/packages',
            data: $scope.package,
        }).then(function (response) {
            $scope.packages_list();
        });
    }


    $scope.package_pay = function () {
        $http({
            method: 'PUT',
            url: 'http://localhost:8080/packages',
            data: $scope.package,
        }).then(function (response) {
            $scope.packages_list();
        });
    }


    // server methods

    $scope.flights_list = function () {
        $http({
            method: 'GET',
            url: 'http://localhost:8080/flights'
        }).then(function (response) {
            $scope.flights = response.data.flights;
        });
    }

    $scope.flight_register = function () {
        $http({
            method: 'POST',
            url: 'http://localhost:8080/flights',
            data: $scope.flight,
        }).then(function (response) {
            $scope.flights_list();
        });
    }

    $scope.flight_cancel = function () {
        $http({
            method: 'DELETE',
            url: 'http://localhost:8080/flights',
            data: $scope.flight,
        }).then(function (response) {
            $scope.flights_list();
        });
    }
    
    

    $scope.hosts_list = function () {
        $http({
            method: 'GET',
            url: 'http://localhost:8080/hosts'
        }).then(function (response) {
            $scope.hosts = response.data.hosts;
        });
    }

    $scope.host_register = function () {
        $http({
            method: 'POST',
            url: 'http://localhost:8080/hosts',
            data: $scope.host,
        }).then(function (response) {
            $scope.hosts_list();
        });
    }
    
    $scope.host_cancel = function () {
        $http({
            method: 'DELETE',
            url: 'http://localhost:8080/hosts',
            data: $scope.host,
        }).then(function (response) {
            $scope.hosts_list();
        });
    }
});
