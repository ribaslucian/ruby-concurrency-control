var app = angular.module('App', []);

app.controller('HotelController', function ($scope, $http) {



    $scope.register = function () {

        console.log($scope.package);

    }
    

    $scope.list = function () {

        $http({
            method: 'GET',
            url: 'localhost/packages'
        }).then(function successCallback(response) {
            console.log(response);
        });

    }

});
